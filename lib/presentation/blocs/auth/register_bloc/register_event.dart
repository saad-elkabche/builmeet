part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}



class UserRegister extends RegisterEvent{
  String nameComplete;
  DateTime dateNaissance;
  String email;
  String password;

  UserRegister(this.nameComplete, this.dateNaissance, this.email, this.password);
}

class PickImage extends RegisterEvent{


}
