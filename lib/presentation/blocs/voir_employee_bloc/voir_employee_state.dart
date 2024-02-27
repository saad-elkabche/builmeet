part of 'voir_employee_bloc.dart';



class VoirEmployeeState {
  AppStatus? operationStatus;
  String? error;
  InterestEntity? interestEntity;

  VoirEmployeeState.empty({required this.interestEntity});

  VoirEmployeeState({this.operationStatus, this.error, this.interestEntity});


  VoirEmployeeState copyWith({AppStatus? operationStatus,String? error,InterestEntity? interestEntity}){
    return VoirEmployeeState(
      operationStatus: operationStatus,
      error: error,
      interestEntity: interestEntity ?? this.interestEntity
    );
  }

}

