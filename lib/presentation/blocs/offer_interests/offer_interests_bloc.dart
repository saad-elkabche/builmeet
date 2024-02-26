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
}
