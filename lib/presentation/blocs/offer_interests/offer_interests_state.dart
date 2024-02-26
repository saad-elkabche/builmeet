part of 'offer_interests_bloc.dart';

class OfferInterestsState {


  AppStatus? fetchingInterestsStatus;
  String? error;
  List<InterestEntity>? interests;
  OfferEntity? offerEntity;


  OfferInterestsState.empty({this.offerEntity});

  OfferInterestsState(
      {this.fetchingInterestsStatus,
      this.error,
      this.interests,
      this.offerEntity});

  OfferInterestsState copyWith({
    AppStatus? fetchingInterestsStatus,
    String? error,
    OfferEntity? offerEntity,
    List<InterestEntity>? interests}){
    return OfferInterestsState(
      error: error,
      fetchingInterestsStatus: fetchingInterestsStatus ?? this.fetchingInterestsStatus,
      interests: interests ?? this.interests,
      offerEntity: offerEntity ?? this.offerEntity
    );
  }


}

