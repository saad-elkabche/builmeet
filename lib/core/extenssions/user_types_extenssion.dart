





import 'package:builmeet/core/constants/enums.dart';

extension ToUserType on String{

   UserTypes get userType{
    return this=='client'?UserTypes.client:UserTypes.employee;
  }

}


extension ToUserTypeString on UserTypes{
  String getString(){
    return this==UserTypes.client?'client':'employee';
  }
}