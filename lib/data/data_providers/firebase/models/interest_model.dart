import 'package:builmeet/core/extenssions/interests_status_extension.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class InterestModel{
  String? interestStatus;
  double? interestPrice;
  UserModel? user;
  OfferModel? offer;
  DateTime? dateCreation;

  InterestModel(
      {this.interestStatus,this.dateCreation,this.interestPrice, this.user, this.offer});

  factory InterestModel.fromJson(Map<String,dynamic> json){
    return InterestModel(
      interestPrice:json['interestPrice']!=null? double.parse(json['interestPrice'].toString()):null,
      interestStatus: json['interestStatus'],
      dateCreation: (json['dateCreation'] as Timestamp).toDate()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'interestPrice':interestPrice,
      'interestStatus':interestStatus,
      'idOffer':offer?.offerId,
      'idEmployee':user?.uid,
      'dateCreation':Timestamp.now()
    };
  }

  static InterestModel toInterestModel(InterestEntity interestEntity){
    return InterestModel(
      interestPrice: interestEntity.interestPrice,
      interestStatus: interestEntity.interestStatus?.interestStatusString,
      user:interestEntity.user!=null? UserModel.toUserModel(interestEntity.user!):null,
      offer:interestEntity.offer!=null? OfferModel.toOfferModel(interestEntity.offer!):null
    );
  }

  InterestEntity toInterestEntity(){
    return InterestEntity(
      dateCreation: dateCreation,
      interestStatus: interestStatus?.interestStatus,
      user: user?.toUserEntity(),
      offer: offer?.toOfferEntity(),
      interestPrice: interestPrice
    );
  }

  InterestModel copyWith({UserModel? user,String? insterestStatus,OfferModel? offer}){
    return InterestModel(
      user: user ?? this.user,
      offer: offer ?? this.offer,
      dateCreation: dateCreation,
      interestStatus: insterestStatus ?? this.interestStatus,
      interestPrice: interestPrice,
    );
  }

  Map<String,dynamic> jsonForUpdateStatus(){
    return {
      'interestStatus':interestStatus
    };
  }



}