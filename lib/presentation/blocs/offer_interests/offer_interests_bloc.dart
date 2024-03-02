import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:meta/meta.dart';

part 'offer_interests_event.dart';
part 'offer_interests_state.dart';

class OfferInterestsBloc extends Bloc<OfferInterestsEvent, OfferInterestsState> {

  Repository repository;


  OfferInterestsBloc({required this.repository,required OfferEntity offerEntity})
      : super(OfferInterestsState.empty(offerEntity:offerEntity )) {
    on<FetchInterests>(_fetchInterestsOffer);
    on<AcceptInterest>(_acceptInterest);
    on<RefuseInterest>(_refuseInterest);
  }

  FutureOr<void> _fetchInterestsOffer(FetchInterests event, Emitter<OfferInterestsState> emit) async{
    try{
      emit(state.copyWith(fetchingInterestsStatus: AppStatus.loading));
      List<InterestEntity> interests=await repository.getInterests(state.offerEntity!);
      emit(state.copyWith(fetchingInterestsStatus: AppStatus.success,interests: interests));
    }catch(ex){
      emit(state.copyWith(fetchingInterestsStatus: AppStatus.error));
    }
  }

  FutureOr<void> _acceptInterest(AcceptInterest event, Emitter<OfferInterestsState> emit) async{
    try{
      emit(state.copyWith(operationStatus: AppStatus.loading));
      InterestEntity interestEntity=event.interestEntity;

      double? price=interestEntity.interestPrice;
      OfferEntity newOffer=interestEntity.offer!.copyWith(employee: interestEntity.user,price: price);
      InterestEntity newInterest=interestEntity.copyWith(offerEntity: newOffer);
      InterestEntity interestEntityRes=await repository.acceptInterest(newInterest);

      emit(state.copyWith(operationStatus: AppStatus.success));
      add(FetchInterests());
    }catch(ex){
      emit(state.copyWith(operationStatus: AppStatus.error));
    }
  }

  FutureOr<void> _refuseInterest(RefuseInterest event, Emitter<OfferInterestsState> emit) async{
    try{
      emit(state.copyWith(operationStatus: AppStatus.loading));
      await repository.refuseInterest(event.interestEntity);
      emit(state.copyWith(operationStatus: AppStatus.success));
      add(FetchInterests());
    }catch(ex){
      emit(state.copyWith(operationStatus: AppStatus.error));
    }
  }
}
