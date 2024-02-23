part of 'profile_bloc.dart';

class ProfileState {

  static const String updateNameIntent='updateNameIntent';
  static const String updateEmailIntent='updateEmailIntent';
  static const String updateProfileImgIntent='updateProfileImgIntent';
  static const String updatePasswordIntent='updatePassIntent';


  UserTypes? appMode;
  AppStatus? fetchingDataStatus;
  String? error;
  String? message;
  AppStatus? updateStatus;
  UserEntity? userEntity;
  String? intent;


  ProfileState.empty();


  ProfileState({this.intent,this.userEntity,this.message,this.updateStatus,this.appMode,this.error,this.fetchingDataStatus});


  ProfileState copyWith({
    AppStatus? fetchingDataStatus,
    String? error,
    AppStatus? updateStatus,
    UserTypes? appMode,
    String? message,
    String? intent,
    UserEntity? user}){

    return ProfileState(
      fetchingDataStatus: fetchingDataStatus ?? this.fetchingDataStatus,
      error: error,
      message: message,
      updateStatus: updateStatus,
      appMode: appMode ?? this.appMode,
      userEntity: user ?? userEntity,
      intent: intent
    );
  }


}

