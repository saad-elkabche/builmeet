part of 'edit_employee_info_bloc.dart';

class EditEmployeeInfoState {

  UserEntity? userEntity;
  List<String>? metiers;
  File? document;
  AppStatus? editinfosStatus;
  String? error;

  EditEmployeeInfoState.empty(this.userEntity){
    metiers=userEntity!.metiers;
  }

  EditEmployeeInfoState({this.userEntity,this.error,this.editinfosStatus, this.metiers, this.document});

  EditEmployeeInfoState copyWith({AppStatus? editinfosStatus,
    String? error,
    UserEntity? userEntity,
    File? document,
    List<String>? metiers}){

    return EditEmployeeInfoState(
      document: document ?? this.document,
      metiers: metiers ?? this.metiers,
      userEntity: userEntity ?? this.userEntity,
      error: error,
      editinfosStatus:editinfosStatus  ?? this.editinfosStatus
    );
  }

}


