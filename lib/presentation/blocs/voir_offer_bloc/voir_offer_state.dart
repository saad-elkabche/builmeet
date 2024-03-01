part of 'voir_offer_cubit.dart';



class VoirOfferState {

  AppStatus? finishOfferStatus;
  String? error;
  OfferEntity? offerEntity;


  VoirOfferState({this.finishOfferStatus, this.error, this.offerEntity});

  VoirOfferState.empty({required this.offerEntity});

  VoirOfferState copyWith({OfferEntity? offer,String?error,AppStatus? finishOfferStatus}){
    return VoirOfferState(
      offerEntity: offer ?? this.offerEntity,
      finishOfferStatus: finishOfferStatus ?? this.finishOfferStatus,
      error: error
    );
  }



}

