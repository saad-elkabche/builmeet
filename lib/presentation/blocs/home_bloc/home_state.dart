part of 'home_bloc.dart';

class HomeState {

  AppStatus? fetchingDataStatus;
  List<OfferEntity>? offers;
  String? error;
  UserTypes? appMode;

  AppStatus? operationStatus;
  String? message;

  HomeState.empty();

  HomeState({this.fetchingDataStatus,this.operationStatus,this.message, this.appMode,this.offers, this.error});


  HomeState copyWith({AppStatus? fetchDataStatus,String? message,AppStatus? operationStatus,UserTypes? appMode,String? error, List<OfferEntity>? offers}){
    return HomeState(
      error: error,
      message: message,
      operationStatus: operationStatus ,
      appMode: appMode ?? this.appMode,
      fetchingDataStatus: fetchDataStatus ?? fetchingDataStatus,
      offers: offers ?? this.offers
    );
  }

}


