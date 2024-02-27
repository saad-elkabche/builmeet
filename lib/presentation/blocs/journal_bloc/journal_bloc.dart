import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:meta/meta.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {

  Repository repository;
  SharedPrefService sharedPrefService;


  JournalBloc({required this.repository,required this.sharedPrefService})
      : super(JournalState.empty()){
    setAppMode();
    on<FetchData>(_fetchData);
  }

  FutureOr<void> _fetchData(FetchData event, Emitter<JournalState> emit) async{
    try{
      emit(state.copyWith(fetchingDataStatus: AppStatus.loading));
      if(state.appMode==UserTypes.client){
        List<OfferEntity> offers = await repository.getAllOffersForClient();
        emit(state.copyWith(
            fetchingDataStatus: AppStatus.success, offers: offers));
      }else{

      }
    }catch(ex){
      emit(state.copyWith(fetchingDataStatus: AppStatus.error));
    }
  }

  void setAppMode() {
    String appModeStr;
    if(!sharedPrefService.contains(SharedPrefService.app_mode)){
      sharedPrefService.putValue(SharedPrefService.app_mode, UserTypes.client.getString());
    }
    appModeStr=sharedPrefService.getValue(SharedPrefService.app_mode, UserTypes.client.getString());
    UserTypes appMode=appModeStr.userType;
    emit(state.copyWith(appMode: appMode));
  }
}
