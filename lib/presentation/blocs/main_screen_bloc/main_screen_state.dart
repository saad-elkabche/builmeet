part of 'main_screen_bloc.dart';

class MainScreenState {

  UserTypes? appMode;
  UserEntity? userEntity;
  AppStatus? fetchUserStatus;
  bool isAuth=true;

  MainScreenState.empty();

  MainScreenState({this.appMode,required this.isAuth, this.userEntity, this.fetchUserStatus});


  MainScreenState copyWith({AppStatus? fetchingUserStatus,bool? isAuth,UserEntity? userEntity,UserTypes? appMode}){
    return MainScreenState(
      userEntity: userEntity ?? this.userEntity,
      appMode: appMode ?? this.appMode,
      fetchUserStatus: fetchingUserStatus ?? this.fetchUserStatus,
      isAuth: isAuth ?? this.isAuth
    );
  }

}

