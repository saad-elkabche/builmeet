
import 'dart:io';

import 'package:builmeet/core/constants/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';







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


  UserEntity copyWith({String? email,
    String? password,
    File? imgProfile,
    File? document,
    UserTypes? type,
    String? address,
    String? description,
    List<String>? metiers,
    String? name}){

    return UserEntity(
      nomComplet: name ?? nomComplet,
      profilePicUrl: profilePicUrl,
      description: description,
      address: address,
      password: password ?? this.password,
      adressEmail: email ?? adressEmail,
      nbRates: nbRates,
      rate: rate,
      type: type ?? this.type,
      imgProfile:imgProfile ?? this.imgProfile,
      dateNaissance: dateNaissance,
      document: document ?? this.document,
      metiers: metiers ?? this.metiers,
      documentPicUrl: documentPicUrl,
      id: id,
    );
  }

}