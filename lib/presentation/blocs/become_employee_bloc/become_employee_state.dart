part of 'become_employee_bloc.dart';

class BecomeEmployeeState {

  List<String>? metiers;
  AppStatus? becomeEmployeeStatus;
  String? error;
  File? document;
  UserEntity? userEntity;

  BecomeEmployeeState.empty(this.userEntity);

  BecomeEmployeeState({this.metiers,this.userEntity,this.document, this.becomeEmployeeStatus, this.error});

  BecomeEmployeeState copyWith({
    AppStatus? becomeEmplyeeStatus,
    String? error,
    File? document,
    UserEntity? userEntity,
    List<String>? metiers}){

    return BecomeEmployeeState(
      error: error,
      userEntity: userEntity ?? this.userEntity,
      document: document ?? this.document,
      becomeEmployeeStatus: becomeEmplyeeStatus ?? this.becomeEmployeeStatus,
      metiers: metiers ?? this.metiers
    );

  }

}

