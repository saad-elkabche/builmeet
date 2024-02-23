part of 'become_employee_bloc.dart';

@immutable
abstract class BecomeEmployeeEvent {}



class AddMetier extends BecomeEmployeeEvent{
  String metier;
  AddMetier(this.metier);
}

class DeleteMetier extends BecomeEmployeeEvent{
  int index;

  DeleteMetier(this.index);
}

class PickDocument extends BecomeEmployeeEvent{

}


class Confimer extends BecomeEmployeeEvent{
  String address;
  String description;
  Confimer(this.address, this.description);
}

