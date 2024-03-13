part of 'edit_employee_info_bloc.dart';

class EditEmployeeInfoState {

  UserEntity? userEntity;
  List<String>? metiers;
  List<File>? documents;
  AppStatus? editinfosStatus;
  AppStatus? deleteRemoteStatus;
  String? error;

  EditEmployeeInfoState.empty(this.userEntity){
    metiers=userEntity!.metiers;
  }

  EditEmployeeInfoState({this.userEntity,this.deleteRemoteStatus,this.error,this.editinfosStatus, this.metiers, this.documents});

  EditEmployeeInfoState copyWith({
    AppStatus? editinfosStatus,
    AppStatus? deleteRemoteStatus,
    String? error,
    UserEntity? userEntity,
    List<File>? documents,
    List<String>? metiers}){

    return EditEmployeeInfoState(
      documents: documents ?? this.documents,
      metiers: metiers ?? this.metiers,
      userEntity: userEntity ?? this.userEntity,
      error: error,
      deleteRemoteStatus: deleteRemoteStatus,
      editinfosStatus:editinfosStatus  ?? this.editinfosStatus
    );
  }

}


