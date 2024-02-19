import 'dart:io';

import 'package:builmeet/core/constants/enums.dart';







class UserEntity{


  String? id;
  String? nomComplet;
  DateTime? dateNaissance;
  String? adressEmail;
  String? password;
  File? imgProfile;
  UserTypes? type;
  List<String>? metiers;
  String? address;
  String? description;
  File? document;
  double? rate;
  int? nbRates;
  String? profilePicUrl;
  String? documentPicUrl;

  UserEntity(
      {this.nomComplet,
        this.id,
      this.dateNaissance,
      this.adressEmail,
      this.password,
      this.imgProfile,
      this.type,
      this.metiers,
      this.address,
      this.description,
      this.document,
      this.rate,
      this.profilePicUrl,
      this.documentPicUrl,
      this.nbRates});
}