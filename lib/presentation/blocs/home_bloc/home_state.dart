part of 'home_bloc.dart';

class HomeState {

  AppStatus? fetchingDataStatus;
  List<OfferEntity>? offers;
  String? error;
  UserTypes? appMode;

  HomeState.empty();

  HomeState({this.fetchingDataStatus, this.appMode,this.offers, this.error});


  HomeState copyWith({AppStatus? fetchDataStatus,UserTypes? appMode,String? error, List<OfferEntity>? offers}){
    return HomeState(
      error: error,
      appMode: appMode ?? this.appMode,
      fetchingDataStatus: fetchDataStatus ?? fetchingDataStatus,
      offers: offers ?? this.offers
    );
  }

}


