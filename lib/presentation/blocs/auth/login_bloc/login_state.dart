part of 'login_bloc.dart';

 class LoginState {

   AppStatus? loginStatus;
   String? error;
   UserEntity? userEntity;


   LoginState.empty();
   LoginState({this.loginStatus, this.error, this.userEntity});


   LoginState copyWith({AppStatus? loginStatus,String? error,UserEntity? userEntity}){
     return LoginState(
       error: error ,
       userEntity: userEntity ?? this.userEntity,
       loginStatus: loginStatus ?? this.loginStatus
     );
   }

}


