import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:meta/meta.dart';

part 'voir_employee_event.dart';
part 'voir_employee_state.dart';

class VoirEmployeeBloc extends Bloc<VoirEmployeeEvent, VoirEmployeeState> {

  Repository repository;

  VoirEmployeeBloc({required this.repository,required InterestEntity interestEntity})
      : super(VoirEmployeeState.empty(interestEntity: interestEntity)) {
   on<AcceptInterest>(_acceptInterest);
   on<RefuseInterest>(_refuseInterest);
  }

  FutureOr<void> _acceptInterest(AcceptInterest event, Emitter<VoirEmployeeState> emit) async{
    try{
      emit(state.copyWith(operationStatus: AppStatus.loading));
      InterestEntity interestEntity = state.interestEntity!;

      double? newPrice=interestEntity.interestPrice;

      OfferEntity newOffer =
          interestEntity.offer!.copyWith(employee: interestEntity.user,price: newPrice);
      InterestEntity newInterest =
          interestEntity.copyWith(offerEntity: newOffer);
      InterestEntity interestEntityRes =
          await repository.acceptInterest(newInterest);
      emit(state.copyWith(
          operationStatus: AppStatus.success,
          interestEntity: interestEntityRes));
    }catch(ex){
      emit(state.copyWith(operationStatus: AppStatus.error));
    }
  }

  FutureOr<void> _refuseInterest(RefuseInterest event, Emitter<VoirEmployeeState> emit) async{
    try{
      emit(state.copyWith(operationStatus: AppStatus.loading));
      await repository.refuseInterest(state.interestEntity!);
      emit(state.copyWith(operationStatus: AppStatus.success));
    }catch(ex){
      emit(state.copyWith(operationStatus: AppStatus.error));
    }
  }
}
