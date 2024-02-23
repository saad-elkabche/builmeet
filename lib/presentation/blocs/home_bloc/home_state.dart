part of 'home_bloc.dart';

class HomeState {

  AppStatus? fetchingDataStatus;
  List<OfferEntity>? offers;
  String? error;

  HomeState.empty();

  HomeState({this.fetchingDataStatus, this.offers, this.error});


  HomeState copyWith({AppStatus? fetchDataStatus, String? error, List<OfferEntity>? offers}){
    return HomeState(
      error: error ,
      fetchingDataStatus: fetchDataStatus ?? fetchingDataStatus,
      offers: offers ?? this.offers
    );
  }

}


