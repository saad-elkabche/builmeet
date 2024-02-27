part of 'journal_bloc.dart';

class JournalState {

  AppStatus? fetchingDataStatus;
  String? error;
  List<OfferEntity>? offersForClient;
  List<InterestEntity>? interestsForEmployee;
  UserTypes? appMode;

  JournalState.empty();

  JournalState(
      {this.fetchingDataStatus,
      this.error,
      this.offersForClient,
      this.interestsForEmployee,
      this.appMode});

  JournalState copyWith({
    String? error,
    UserTypes? appMode,
    AppStatus? fetchingDataStatus,
    List<OfferEntity>? offers,
    List<InterestEntity>? interests}){

    return JournalState(
      error: error,
      appMode: appMode ?? this.appMode,
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


