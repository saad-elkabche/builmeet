import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  StreamSubscription<MainScreenState>? streamSubscription;
  Repository repository;
  SharedPrefService sharedPrefService;

  HomeBloc({required this.repository,required this.sharedPrefService}) : super(HomeState.empty()) {
    setAppMode();
    on<FetchOffers>(_fetchData);
    on<ListeneToMainScreen>(_listenToMainSecreenState);
  }



  FutureOr<void> _listenToMainSecreenState(ListeneToMainScreen event, Emitter<HomeState> emit) {
    streamSubscription = event.mainScreenBloc.stream.listen(
     (mainSecreenState) {
       if(mainSecreenState is AppModeChanged){
          setAppMode();
          add(FetchOffers());
       }

    });
  }

  FutureOr<void> _fetchData(FetchOffers event, Emitter<HomeState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      List<OfferEntity> offers;
      if(state.appMode==UserTypes.client){
        offers=await repository.getOfferForClient();
      }else{
        offers=await repository.getOfferForClient();
      }
      emit(state.copyWith(fetchDataStatus: AppStatus.success,offers: offers));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
    }
  }

  void setAppMode() {
    if(!sharedPrefService.contains(SharedPrefService.app_mode)){
      sharedPrefService.putValue(SharedPrefService.app_mode,UserTypes.client.getString());
    }
    String mode=sharedPrefService.getValue(SharedPrefService.app_mode, UserTypes.client.getString());
    UserTypes appMode=mode.userType;
    emit(state.copyWith(appMode: appMode));
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
