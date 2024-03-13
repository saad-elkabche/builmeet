part of 'become_employee_bloc.dart';

class BecomeEmployeeState {

  List<String>? metiers;
  AppStatus? becomeEmployeeStatus;
  String? error;
  List<File>? documents;
  UserEntity? userEntity;

  BecomeEmployeeState.empty(this.userEntity);

  BecomeEmployeeState({this.metiers,this.userEntity,this.documents, this.becomeEmployeeStatus, this.error});

  BecomeEmployeeState copyWith({
    AppStatus? becomeEmplyeeStatus,
    String? error,
    List<File>? documents,
    UserEntity? userEntity,
    List<String>? metiers}){

    return BecomeEmployeeState(
      error: error,
      userEntity: userEntity ?? this.userEntity,
      documents: documents ?? this.documents,
      becomeEmployeeStatus: becomeEmplyeeStatus ?? this.becomeEmployeeStatus,
      metiers: metiers ?? this.metiers
    );

  }

}

