import 'dart:io';

import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';









class UserModel{


  String? uid;
  String? nomComplet;
  DateTime? dateNaissance;
  String? adressEmail;
  String? password;
  File? imgProfile;
  String? type;
  List<String>? metiers;
  String? address;
  String? description;
  File? document;
  double? rate;
  int? nbRates;
  String? profilePicUrl;
  String? documentUrl;

  UserModel(
      {this.nomComplet,
        this.uid,
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
        this.nbRates,
        this.documentUrl,
        });


  factory UserModel.fromJson(Map<String,dynamic> json,String id){
    return UserModel(
      uid: id,
      rate: double.parse(json['rate'].toString()) ,
      type: json['type'],
      address: json['address'],
      adressEmail: json['email'],
      dateNaissance: (json['dateNaissance'] as Timestamp).toDate(),
      description: json['description'],
      documentUrl: json['documentUrl'],
      profilePicUrl: json['profilePicUrl'],
      metiers: json['metiers']!=null?List.from((json['metiers'] as List).map((e) => e.toString())):json['metiers'],
      nbRates: json['nbRates'],
      nomComplet: json['fullName'],

    );
  }





  Map<String,dynamic> jsonForCreateAccount(){
    return {
      'email':adressEmail,
      'fullName':nomComplet,
      'dateNaissance':dateNaissance,
      'rate':rate,
      'nbRates':nbRates,
      'metiers':metiers,
      'type':type,
      'profilePicUrl':profilePicUrl,
      'documentUrl':documentUrl,
      'address':address,
      'description':description
    };
  }


  UserModel copyWith({
    String? profilePicUrl,
    String? documentUrl,
    String? uid
  }){
    return UserModel(
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      nomComplet: nomComplet,
      nbRates: nbRates,
      metiers: metiers,
      imgProfile: imgProfile,
      document: document,
      description: description,
      dateNaissance: dateNaissance,
      adressEmail: adressEmail,
      address: address,
      type: type,
      rate: rate,
      password: password,
      uid: uid ?? this.uid,
    );
  }





  UserEntity toUserEntity(){
    return UserEntity(
      id: uid,
      nomComplet: nomComplet,
      adressEmail: adressEmail,
      dateNaissance: dateNaissance,
      rate: rate,
      description: description,
      address: address,
      type: type?.userType,
      metiers: metiers,
      profilePicUrl:profilePicUrl,
      documentPicUrl: documentUrl,
      nbRates: nbRates,
    );
  }

  static UserModel toUserModel(UserEntity userEntity){
    return UserModel(
      nbRates: userEntity.nbRates,
      imgProfile: userEntity.imgProfile,
      metiers: userEntity.metiers,
      type: userEntity.type?.getString(),
      address: userEntity.address,
      description: userEntity.description,
      rate: userEntity.rate,
      dateNaissance: userEntity.dateNaissance,
      adressEmail: userEntity.adressEmail,
      password: userEntity.password,
      nomComplet: userEntity.nomComplet,
      document: userEntity.document,
      documentUrl: userEntity.documentPicUrl,
      uid: userEntity.id,
      profilePicUrl: userEntity.profilePicUrl
    );
  }

  Map<String,dynamic> jsonForUpdatingEmail(){
    return {
      'email':adressEmail,
    };
  }
  Map<String,dynamic> jsonForUpdatingName(){
    return {
      'fullName':nomComplet,
    };
  }
  Map<String,dynamic> jsonForUpdatingprofileUrl(){
    return {
      'profilePicUrl':profilePicUrl,
    };
  }
  Map<String,dynamic> jsonEmployeeData(){
    return {
      'documentUrl':documentUrl,
      'address':address,
      'description':description,
      'type':type,
      'metiers':metiers,
    };
  }



}