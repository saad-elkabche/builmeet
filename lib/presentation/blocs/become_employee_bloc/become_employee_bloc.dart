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


  BecomeEmployeeBloc({required this.repository,required this.sharedPrefService}) : super(BecomeEmployeeState.empty()) {

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
    XFile? file=await picker.pickImage(source: ImageSource.gallery);
    if(file!=null){
      File document=File(file.path);
      emit(state.copyWith(document: document));
    }
  }

  FutureOr<void> _confirmer(Confimer event, Emitter<BecomeEmployeeState> emit) async{
    try{
      emit(state.copyWith(becomeEmplyeeStatus: AppStatus.loading));
      UserEntity userEntity=await repository.getCurrentUser();
      userEntity=userEntity.copyWith(
        metiers: state.metiers,
        address: event.address,
        description: event.description,
        document: state.document,
        type: UserTypes.employee
      );
      UserEntity userEntityRes=await repository.bacomeEmployee(userEntity);
      setAppMode(userEntityRes);
      emit(state.copyWith(becomeEmplyeeStatus: AppStatus.success));
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
