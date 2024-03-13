import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/exceptions/email_already_in_use.dart';
import 'package:builmeet/domain/exceptions/weak_pass_exception.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  Repository repository;
  SharedPrefService sharedPrefService;

  RegisterBloc({required this.repository,required this.sharedPrefService}) : super(RegisterState.empty()) {

    on<UserRegister>(_register);
    on<PickImage>(_pickImage);
  }

  FutureOr<void> _register(UserRegister event, Emitter<RegisterState> emit) async{
    try{
      emit(state.copyWith(registerStatus: AppStatus.loading));

      UserEntity userEntity=UserEntity(
        nomComplet: event.nameComplete,
        dateNaissance: event.dateNaissance,
        imgProfile: state.profImage,
        password: event.password,
        adressEmail: event.email,
        type: UserTypes.client,
        rate: 5.0,
        nbRates: 1,
      );

      await repository.register(userEntity);
      setAppMode(userEntity);
      emit(state.copyWith(registerStatus: AppStatus.success));

    }on WeakPassException catch(ex){
      emit(state.copyWith(registerStatus: AppStatus.error,error: ex.toString()));
    }on EmailAlreadyInUse catch(ex){
      emit(state.copyWith(registerStatus: AppStatus.error,error: ex.toString()));
    }catch(ex){
      emit(state.copyWith(registerStatus: AppStatus.error));
      rethrow;
    }


  }
  FutureOr<void> _pickImage(PickImage event, Emitter<RegisterState> emit) async{
    ImagePicker picker=ImagePicker();
    XFile? image=await picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      File file=File(image.path);
      emit(state.copyWith(profImage: file));
    }
  }

  void setAppMode(UserEntity userEntity) {
    String appMode=userEntity.type!.getString();
    sharedPrefService.putValue(SharedPrefService.app_mode, appMode);
  }
}
