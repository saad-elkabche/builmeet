import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  Repository repository;
  SharedPrefService sharedPrefService;
  late StreamSubscription<User?> streamAuthSubscription;


  MainScreenBloc({required this.sharedPrefService,required FirebaseAuth firebaseAuth,required this.repository}) : super(MainScreenState.empty()) {

    on<FetchData>(_fetchData);


    setMode();
    streamAuthSubscription =firebaseAuth.authStateChanges().listen(
      (user) {
        if(user==null){
          emit(state.copyWith(isAuth: false));
        }
    });



  }





  FutureOr<void> _fetchData(FetchData event, Emitter<MainScreenState> emit) async{
    try{
      emit(state.copyWith(fetchingUserStatus: AppStatus.loading));
      UserEntity userEntity=await repository.getCurrentUser();
      emit(state.copyWith(fetchingUserStatus: AppStatus.success,userEntity: userEntity));
    }catch(ex){
      emit(state.copyWith(fetchingUserStatus: AppStatus.error));
    }
  }

  @override
  Future<void> close() {
    streamAuthSubscription.cancel();
    return super.close();
  }

  void setMode() {
    UserTypes appMode;
    String mode=sharedPrefService.getValue(SharedPrefService.app_mode, UserTypes.client.getString());
    if(!sharedPrefService.contains(SharedPrefService.app_mode)){
      sharedPrefService.putValue(SharedPrefService.app_mode, mode);
    }
    appMode=mode.userType;
    emit(state.copyWith(appMode: appMode));
  }
}
