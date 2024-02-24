part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}


class FetchProfileData extends ProfileEvent{

}

class SetAppMode extends ProfileEvent{
  bool isEmployee;

  SetAppMode(this.isEmployee);
}

class UpdateEmail extends ProfileEvent{
  String email;

  UpdateEmail(this.email);
}

class UpdateName extends ProfileEvent{
  String Name;

  UpdateName(this.Name);
}

class UpdatePassword extends ProfileEvent{

  String newPasword;

  UpdatePassword(this.newPasword);
}

class Logout extends ProfileEvent{

}

class PickImageProfle extends ProfileEvent{

}

class RefreshData extends ProfileEvent{
    UserEntity userEntity;

    RefreshData(this.userEntity);
}
