import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'become_employee_event.dart';
part 'become_employee_state.dart';

class BecomeEmployeeBloc extends Bloc<BecomeEmployeeEvent, BecomeEmployeeState> {
  Repository repository;
  SharedPrefService sharedPrefService;


  BecomeEmployeeBloc({required this.repository,required this.sharedPrefService,required UserEntity userEntity})
      : super(BecomeEmployeeState.empty(userEntity)) {

    on<AddMetier>(_addMetier);
    on<DeleteMetier>(_deleteMetier);
    on<PickDocument>(_pickDocument);
    on<Confimer>(_confirmer);
  }

  FutureOr<void> _addMetier(AddMetier event, Emitter<BecomeEmployeeState> emit) {
    List<String> metiers=state.metiers ?? [];
    metiers.add(event.metier);
    emit(state.copyWith(metiers: metiers));
  }

  FutureOr<void> _deleteMetier(DeleteMetier event, Emitter<BecomeEmployeeState> emit) {
    List<String> metiers=state.metiers ?? [];
    metiers.removeAt(event.index);
    emit(state.copyWith(metiers: metiers));
  }

  FutureOr<void> _pickDocument(PickDocument event, Emitter<BecomeEmployeeState> emit) async{
    ImagePicker picker=ImagePicker();
    List<XFile> files=await picker.pickMultiImage();
    if(files.isNotEmpty){
      List<File> documents=[];
      for(XFile file in files){
        File document=File(file.path);
        documents.add(document);
      }
      emit(state.copyWith(documents: documents));
    }
  }

  FutureOr<void> _confirmer(Confimer event, Emitter<BecomeEmployeeState> emit) async{
    try{
      emit(state.copyWith(becomeEmplyeeStatus: AppStatus.loading));
      UserEntity userEntity=state.userEntity!.copyWith(
          metiers: state.metiers,
          address: event.address,
          description: event.description,
          documents: state.documents,
          type: UserTypes.employee
      );
      UserEntity userEntityRes=await repository.setEmployeeData(userEntity);
      setAppMode(userEntityRes);
      emit(state.copyWith(becomeEmplyeeStatus: AppStatus.success,userEntity: userEntityRes));
    }catch(ex){
      emit(state.copyWith(becomeEmplyeeStatus: AppStatus.error));
      rethrow;
    }
  }

  void setAppMode(UserEntity userEntityRes) {
    String newAppMode=userEntityRes.type!.getString();
    sharedPrefService.putValue(SharedPrefService.app_mode, newAppMode);
  }
}
