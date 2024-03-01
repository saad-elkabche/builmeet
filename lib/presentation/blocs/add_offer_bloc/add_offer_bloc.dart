import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/total_mission_calculator.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'add_offer_event.dart';
part 'add_offer_state.dart';

class AddOfferBloc extends Bloc<AddOfferEvent, AddOfferState> {

  Repository repository;



  AddOfferBloc({required this.repository}) : super(AddOfferState.empty()) {
    on<CalculeFees>(_calculateFees);
    on<CreateOffer>(_createOffer);
  }

  FutureOr<void> _calculateFees(CalculeFees event, Emitter<AddOfferState> emit) {


    print('====================${event.price}');
    print('====================${event.nbHour}');
    print('====================${event.dateBegin}');
    print('====================${event.dateEnd}');
    print('====================${event.isByHour}');

    if(
        event.price.isNotEmpty
        && event.nbHour.isNotEmpty
        && event.dateBegin!=null
        && event.dateEnd!=null
    ){

      double price=double.parse(event.price);
      double commision=price*0.1;
      double totalWithCommision;

      if(event.isByHour){
        int nbDays=event.dateEnd!.difference(event.dateBegin!).inDays;

        print('============nb=Days============${nbDays}');

        int nbHoursPerDay=int.parse(event.nbHour);
        int totalHours=nbDays*nbHoursPerDay;
        double totalWithoutCommision=totalHours*price;
        totalWithCommision=totalWithoutCommision*1.1;
      }else{
        totalWithCommision=price*1.1;
      }



      emit(state.copyWith(
          totale: totalWithCommision.toStringAsFixed(2),
          commision: commision.toStringAsFixed(2),
        )
      );


    }else{
      emit(state.clearCalcul());
    }
  }

  FutureOr<void> _createOffer(CreateOffer event, Emitter<AddOfferState> emit) async{
    try{
      emit(state.copyWith(addOfferStatus: AppStatus.loading));

      add(CalculeFees(nbHour: event.nbHour,
          price: event.price,
          isByHour: event.isByHour,
          dateBegin:event.dateBegin,
          dateEnd: event.dateEnd
        )
      );

      UserEntity creator=await repository.getCurrentUser();

      double price;

      if(event.isByHour){
        price=calculTotalMission(
            dateBegin: event.dateBegin,
            dateEnd: event.dateEnd,
            nbHour: int.parse(event.nbHour),
            hourPrice:double.parse(event.price) );
      }else{
        price=double.parse(event.price);
      }


      OfferEntity offerEntity=OfferEntity(
        pricingType: event.isByHour?PricingTypes.hourly:PricingTypes.total,
        orderStatus: OrderStatus.pending,
        creator: creator,
        dateDebut: event.dateBegin,
        dateFin: event.dateEnd,
        nbHourPerDay: int.parse(event.nbHour),
        price: price,
        metier: event.metier,
        address: event.address,
        description: event.description
      );

      await repository.createOffer(offerEntity);
      emit(state.copyWith(addOfferStatus: AppStatus.success));

    }catch(ex){
      emit(state.copyWith(addOfferStatus: AppStatus.error));
      rethrow;
    }
  }
}
