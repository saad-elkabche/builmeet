part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}


class UserLogin extends LoginEvent{
  String email;
  String password;

  UserLogin(this.email, this.password);
}

