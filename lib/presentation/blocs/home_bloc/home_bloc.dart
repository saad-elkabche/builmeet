import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
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
    on<EmployeeInteresser>(_employeeIntersted);
    on<EmployeeNotIntersted>(_employeeNotIntersted);
    on<ClientStopOffer>(_clientStopOffer);

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
        offers=await repository.getOffersForEmployee();
      }
      emit(state.copyWith(fetchDataStatus: AppStatus.success,offers: offers));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
      rethrow;
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

  FutureOr<void> _employeeIntersted(EmployeeInteresser event, Emitter<HomeState> emit) async{
    try{
      emit(state.copyWith(operationStatus: AppStatus.loading));
      UserEntity userEntity=await repository.getCurrentUser();
      InterestEntity interestEntity=InterestEntity(
        interestPrice: event.price,
        offer: event.offerEntity,
        user: userEntity,
        interestStatus: InterestsStatus.pending,
      );
      InterestEntity interestEntityRes=await repository.setEmployeeIntersting(interestEntity);
      event.offerEntity.setInterest=interestEntityRes;
      emit(state.copyWith(operationStatus: AppStatus.success));
    }catch(ex){
      emit(state.copyWith(operationStatus: AppStatus.error));
      rethrow;
    }
  }

  FutureOr<void> _employeeNotIntersted(EmployeeNotIntersted event, Emitter<HomeState> emit) async{
      try{
        emit(state.copyWith(operationStatus: AppStatus.loading));
        await repository.setEmployeeNotIntersting(event.offerEntity);
        state.offers?.removeAt(event.index);
        emit(state.copyWith(operationStatus: AppStatus.success));
      }catch(ex){
        emit(state.copyWith(operationStatus: AppStatus.error));
        rethrow;
      }
  }


  FutureOr<void> _clientStopOffer(ClientStopOffer event, Emitter<HomeState> emit) async{
    try{
      emit(state.copyWith(operationStatus: AppStatus.loading));
      await repository.clientStopOffer(event.offer);
      emit(state.copyWith(operationStatus: AppStatus.success));
      add(FetchOffers());
    }catch(ex){
      emit(state.copyWith(operationStatus: AppStatus.error));
    }
  }
}
