part of 'main_screen_bloc.dart';

class MainScreenState {

  UserTypes? appMode;
  UserEntity? me;
  AppStatus? fetchUserStatus;
  bool isAuth=true;

  MainScreenState.empty();

  MainScreenState({this.appMode,required this.isAuth, this.me, this.fetchUserStatus});


  MainScreenState copyWith({AppStatus? fetchingUserStatus,bool? isAuth,UserEntity? userEntity,UserTypes? appMode}){
    return MainScreenState(
      me: userEntity ?? this.me,
      appMode: appMode ?? this.appMode,
      fetchUserStatus: fetchingUserStatus ?? this.fetchUserStatus,
      isAuth: isAuth ?? this.isAuth
    );
  }

}

