import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/exceptions/requires_recent_login_exception.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  SharedPrefService sharedPrefService;
  Repository repository;

  ProfileBloc(this.repository,this.sharedPrefService) : super(ProfileState.empty()) {


    setAppMode();
    on<FetchProfileData>(_fetchProfData);
    on<SetAppMode>(_setAppMode);
    on<UpdateName>(_updateName);
    on<UpdateEmail>(_updateEmail);
    on<UpdatePassword>(_updatePassword);
    on<Logout>(_logout);
    on<PickImageProfle>(_pickImageProfile);
    on<RefreshData>(_refreshData);



  }

  FutureOr<void> _fetchProfData(FetchProfileData event, Emitter<ProfileState> emit) async{
    try{
      emit(state.copyWith(fetchingDataStatus: AppStatus.loading));

      UserEntity userEntity=await repository.getCurrentUser();

      emit(state.copyWith(fetchingDataStatus: AppStatus.success,user: userEntity));
    }catch(ex){
      emit(state.copyWith(fetchingDataStatus: AppStatus.error,));
    }
  }

  void setAppMode() {
    String mode;
    if(sharedPrefService.contains(SharedPrefService.app_mode)){
      mode=sharedPrefService.getValue(SharedPrefService.app_mode, UserTypes.client.getString());
    }else{
      sharedPrefService.putValue(SharedPrefService.app_mode, UserTypes.client.getString());
      mode=sharedPrefService.getValue(SharedPrefService.app_mode, UserTypes.client.getString());
    }
    UserTypes appMode=mode.userType;
    emit(state.copyWith(appMode: appMode));
  }



  FutureOr<void> _setAppMode(SetAppMode event, Emitter<ProfileState> emit) {
    String newMode;
    if(event.isEmployee){
      newMode=UserTypes.employee.getString();
    }else{
      newMode=UserTypes.client.getString();
    }
    sharedPrefService.putValue(SharedPrefService.app_mode, newMode);
    setAppMode();
  }

  FutureOr<void> _updateName(UpdateName event, Emitter<ProfileState> emit) async{
    try{
      emit(state.copyWith(updateStatus: AppStatus.loading));
      UserEntity userEntity=state.userEntity!;
      userEntity=userEntity.copyWith(name: event.Name);
      UserEntity userEntityRes=await repository.updateName(userEntity);
      emit(state.copyWith(updateStatus: AppStatus.success,user: userEntityRes,intent: ProfileState.updateNameIntent));
    }catch(ex){
      emit(state.copyWith(updateStatus: AppStatus.error));
      rethrow;
    }
  }

  FutureOr<void> _updateEmail(UpdateEmail event, Emitter<ProfileState> emit) async{
    try{
      emit(state.copyWith(updateStatus: AppStatus.loading));
      UserEntity userEntity=state.userEntity!;
      userEntity=userEntity.copyWith(email: event.email);
      await repository.updateEmail(userEntity);
      emit(state.copyWith(
          updateStatus: AppStatus.success,
          intent: ProfileState.updateEmailIntent,
          message: 'we have Sent you an\nEmail verification'));
    }on RequiresRecentLoginException catch(ex){
     emit(state.copyWith(updateStatus: AppStatus.error,error: ex.toString()));
    }catch(ex){
      emit(state.copyWith(updateStatus: AppStatus.error,));
      print('====================${ex.runtimeType}');
      rethrow;
    }
  }

  FutureOr<void> _updatePassword(UpdatePassword event, Emitter<ProfileState> emit) async{
    try{
      emit(state.copyWith(updateStatus: AppStatus.loading));
      UserEntity userEntity=state.userEntity!;
      userEntity=userEntity.copyWith(password: event.newPasword);
      await repository.updatePassword(userEntity);
      emit(state.copyWith(updateStatus: AppStatus.success,intent: ProfileState.updatePasswordIntent));
    }on RequiresRecentLoginException catch(ex){
      emit(state.copyWith(updateStatus: AppStatus.error,error: ex.toString()));
    }catch(ex){
      emit(state.copyWith(updateStatus: AppStatus.error));
      if(ex is FirebaseAuthException){
        print('=====code======${ex.code}');
      }
      rethrow;
    }
  }

  FutureOr<void> _logout(Logout event, Emitter<ProfileState> emit) async{
    try{
      await repository.signOut();
    }catch(ex){

    }
  }

  FutureOr<void> _pickImageProfile(PickImageProfle event, Emitter<ProfileState> emit) async{
    try{

      ImagePicker picker=ImagePicker();
      XFile? file=await picker.pickImage(source: ImageSource.gallery);
      if(file!=null){
        emit(state.copyWith(updateStatus: AppStatus.loading));
        File newFile=File(file.path);
        UserEntity userEntity=state.userEntity!;
        userEntity=userEntity.copyWith(imgProfile: newFile);
        UserEntity newUserEntity=await repository.updateProfileImg(userEntity);
        emit(state.copyWith(updateStatus: AppStatus.success,user: newUserEntity));
      }

    }catch(ex){
      emit(state.copyWith(updateStatus: AppStatus.error));
    }
  }

  FutureOr<void> _refreshData(RefreshData event, Emitter<ProfileState> emit) {
    setAppMode();
    add(FetchProfileData());
  }
}
