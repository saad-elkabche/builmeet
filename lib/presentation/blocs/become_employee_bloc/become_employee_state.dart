part of 'become_employee_bloc.dart';

class BecomeEmployeeState {

  List<String>? metiers;
  AppStatus? becomeEmployeeStatus;
  String? error;
  File? document;

  BecomeEmployeeState.empty();

  BecomeEmployeeState({this.metiers,this.document, this.becomeEmployeeStatus, this.error});

  BecomeEmployeeState copyWith({
    AppStatus? becomeEmplyeeStatus,
    String? error,
    File? document,
    List<String>? metiers}){

    return BecomeEmployeeState(
      error: error,
      document: document ?? this.document,
      becomeEmployeeStatus: becomeEmplyeeStatus ?? this.becomeEmployeeStatus,
      metiers: metiers ?? this.metiers
    );

  }

}

