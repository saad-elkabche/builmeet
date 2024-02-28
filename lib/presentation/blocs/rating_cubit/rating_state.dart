part of 'rating_cubit.dart';

class RatingState {

  OfferEntity? offerEntity;
  AppStatus? ratingStatus;
  UserTypes? appMode;
  String? error;

  RatingState.empty({required this.offerEntity});

  RatingState({this.offerEntity, this.ratingStatus, this.appMode, this.error});


  RatingState copyWith({AppStatus? ratingStatus,String?error,OfferEntity? offerEntity,UserTypes? appMode}){
    return RatingState(
      appMode: appMode ?? this.appMode,
      error: error,
      offerEntity: offerEntity ?? this.offerEntity,
      ratingStatus: ratingStatus ?? this.ratingStatus
    );
  }

}

