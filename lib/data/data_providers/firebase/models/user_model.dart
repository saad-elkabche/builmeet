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
  List<File>? documents;
  double? rate;
  int? nbRates;
  String? profilePicUrl;
  List<String>? documentUrls;

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
        this.documents,
        this.rate,
        this.profilePicUrl,
        this.nbRates,
        this.documentUrls,
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
      documentUrls: json['documentUrls']!=null?(json['documentUrls'] as List).map((e) => e.toString()).toList():null,
      profilePicUrl: json['profilePicUrl'],
      metiers: json['metiers']!=null?List.from((json['metiers'] as List).map((e) => e.toString())):json['metiers'],
      nbRates: json['nbRates'],
      nomComplet: json['fullName'],

    );
  }







  UserModel copyWith({
    String? profilePicUrl,
    List<String>? documentUrls,
    String? uid,
    int? nbRates,
    double? rate
  }){
    return UserModel(
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      documentUrls: documentUrls ?? this.documentUrls,
      nomComplet: nomComplet,
      nbRates: nbRates ?? this.nbRates,
      metiers: metiers,
      imgProfile: imgProfile,
      documents: documents,
      description: description,
      dateNaissance: dateNaissance,
      adressEmail: adressEmail,
      address: address,
      type: type,
      rate: rate ?? this.rate,
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
      documentPicUrls: documentUrls,
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
      documents: userEntity.documents,
      documentUrls: userEntity.documentPicUrls,
      uid: userEntity.id,
      profilePicUrl: userEntity.profilePicUrl
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
      'documentUrls':documentUrls,
      'address':address,
      'description':description
    };
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
      'documentUrls':documentUrls,
      'address':address,
      'description':description,
      'type':type,
      'metiers':metiers,
    };
  }

  Map<String,dynamic> jsonForUpdatingRate(){
    return {
      'rate':rate,
      'nbRates':nbRates,
    };
  }

  Map<String,dynamic> jsonForUpdateDocumentUrls(){
    return{
      'documentUrls':documentUrls
    };
  }



}