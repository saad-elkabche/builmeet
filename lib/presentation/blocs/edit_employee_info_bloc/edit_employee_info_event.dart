part of 'edit_employee_info_bloc.dart';

@immutable
abstract class EditEmployeeInfoEvent {}


class AddMetier extends EditEmployeeInfoEvent{
  String metier;

  AddMetier(this.metier);
}

class DeleteMetier extends EditEmployeeInfoEvent{
  int index;

  DeleteMetier(this.index);
}

class PickImage extends EditEmployeeInfoEvent{

}

class UpdateEmployeeInfos extends EditEmployeeInfoEvent{
  String address;
  String description;

  UpdateEmployeeInfos(this.address, this.description);
}
