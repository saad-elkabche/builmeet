import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/exceptions/no_user_found_for_that_email.dart';
import 'package:builmeet/domain/exceptions/wrong_password.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Repository repository;
  SharedPrefService sharedPrefService;

  LoginBloc({required this.repository,required this.sharedPrefService}) : super(LoginState.empty()) {

    on<UserLogin>(_login);

  }

  FutureOr<void> _login(UserLogin event, Emitter<LoginState> emit) async{
    try{
      emit(state.copyWith(loginStatus: AppStatus.loading));

      UserEntity user=UserEntity(
        adressEmail: event.email,
        password: event.password
      );
      UserEntity userRes=await repository.login(user);
      setMode(userRes);
      emit(state.copyWith(loginStatus: AppStatus.success,userEntity: userRes));

    }on InvalidCredential catch(ex){
      emit(state.copyWith(loginStatus: AppStatus.error,error: ex.toString()));
    }on WrongPassword catch(ex){
      emit(state.copyWith(loginStatus: AppStatus.error,error: ex.toString()));
    }catch(ex){

      emit(state.copyWith(loginStatus: AppStatus.error,error: 'error'));
    }
  }

  void setMode(UserEntity userRes) {
    String mode=userRes.type!.getString();
    sharedPrefService.putValue(SharedPrefService.app_mode, mode);
  }
}
