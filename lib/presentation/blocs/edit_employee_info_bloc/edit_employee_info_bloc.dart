import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_employee_info_event.dart';
part 'edit_employee_info_state.dart';

class EditEmployeeInfoBloc extends Bloc<EditEmployeeInfoEvent, EditEmployeeInfoState> {

  Repository repository;
  SharedPrefService sharedPrefService;


  EditEmployeeInfoBloc({required UserEntity userEntity,required this.sharedPrefService,required this.repository})
      : super(EditEmployeeInfoState.empty(userEntity)) {
    on<PickImage>(_pickImage);
    on<AddMetier>(_addMetier);
    on<DeleteMetier>(_deleteMetier);
    on<UpdateEmployeeInfos>(_updateEmployeeInfos);
  }

  FutureOr<void> _pickImage(PickImage event, Emitter<EditEmployeeInfoState> emit) async{
    ImagePicker picker=ImagePicker();
    XFile? file=await picker.pickImage(source: ImageSource.gallery);
    if(file!=null){
      File document=File(file.path);
      emit(state.copyWith(document:document));
    }
  }

  FutureOr<void> _addMetier(AddMetier event, Emitter<EditEmployeeInfoState> emit) {
    List<String> metiers=state.metiers ?? [];
    metiers.add(event.metier);
    emit(state.copyWith(metiers: metiers));
  }

  FutureOr<void> _deleteMetier(DeleteMetier event, Emitter<EditEmployeeInfoState> emit) {
    List<String> metiers=state.metiers ?? [];
    metiers.removeAt(event.index);
    emit(state.copyWith(metiers: metiers));
  }

  FutureOr<void> _updateEmployeeInfos(UpdateEmployeeInfos event, Emitter<EditEmployeeInfoState> emit) async{
    try{
      emit(state.copyWith(editinfosStatus: AppStatus.loading));
      UserEntity newUser=state.userEntity!.copyWith(
        description: event.description,
        address: event.address,
        document: state.document,
        metiers: state.metiers
      );
      UserEntity userEntityRes=await repository.setEmployeeData(newUser);
      emit(state.copyWith(editinfosStatus: AppStatus.success,userEntity: userEntityRes));
    }catch(ex){
      emit(state.copyWith(editinfosStatus: AppStatus.error));
    }
  }
}
