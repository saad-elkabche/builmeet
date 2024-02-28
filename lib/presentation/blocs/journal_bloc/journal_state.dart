part of 'journal_bloc.dart';

enum Operations{
  finishOffer,
}


class JournalState {

  AppStatus? fetchingDataStatus;
  AppStatus? operationStatus;
  String? error;
  OfferEntity? operationOnOffer;
  List<OfferEntity>? offersForClient;
  List<InterestEntity>? interestsForEmployee;
  UserTypes? appMode;
  Operations? currentOperation;



  JournalState.empty();

  JournalState(
      {this.fetchingDataStatus,
      this.error,
      this.operationStatus,
      this.offersForClient,
      this.interestsForEmployee,
      this.operationOnOffer,
      this.currentOperation,
      this.appMode});

  JournalState copyWith({
    AppStatus? operationStatus,
    String? error,
    UserTypes? appMode,
    AppStatus? fetchingDataStatus,
    List<OfferEntity>? offers,
    OfferEntity? operationOnOffer,
    Operations? currentOperation,
    List<InterestEntity>? interests}){

    return JournalState(
      error: error,
      currentOperation: currentOperation ?? this.currentOperation,
      operationStatus: operationStatus,
      appMode: appMode ?? this.appMode,
      operationOnOffer: operationOnOffer ?? this.operationOnOffer,
      fetchingDataStatus: fetchingDataStatus ?? this.fetchingDataStatus,
      interestsForEmployee: interests ?? this.interestsForEmployee,
      offersForClient: offers ?? this.offersForClient,
    );
  }

  List<OfferEntity> getActifOffersForClient(){
    List<OfferEntity> offers=offersForClient?.where((element) => element.orderStatus==OrderStatus.active).toList() ?? [];
    return offers;
  }
  List<OfferEntity> getFinishedOffersForClient(){
    List<OfferEntity> offers=offersForClient?.where(
            (element) => element.orderStatus==OrderStatus.finished).toList() ?? [];
    return offers;
  }

}


