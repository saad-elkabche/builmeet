part of 'add_offer_bloc.dart';

class AddOfferState {
  AppStatus? addOfferStatus;
  String? error;
  String? commision;
  String? totale;

  AddOfferState.empty();
  AddOfferState({
    this.commision,
    this.totale,
    this.error,
    this.addOfferStatus
});

  AddOfferState copyWith({String? commision,String? error,AppStatus? addOfferStatus,String? totale}){
    return AddOfferState(
      commision: commision ?? this.commision,
      totale: totale ?? this.totale,
      error: error,
      addOfferStatus:addOfferStatus ?? this.addOfferStatus
    );
  }

  AddOfferState clearCalcul(){
    return AddOfferState(
      totale: null,
      commision: null,
      error: error,
      addOfferStatus: addOfferStatus
    );
  }



}

