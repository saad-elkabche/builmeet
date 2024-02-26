





import 'package:builmeet/core/extenssions/order_status_extension.dart';
import 'package:builmeet/core/extenssions/pricing_types_extension.dart';
import 'package:builmeet/data/data_providers/firebase/models/interest_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel{
  String? offerId;
  String? metier;
  String? description;
  String? address;
  double? price;
  String? pricingType;
  DateTime? dateCreation;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? nbHourPerDay;
  String? orderStatus;
  UserModel? creator;
  UserModel? employee;
  InterestModel? myInterest;
  int? interestsCount;


  OfferModel({
      this.offerId,
      this.metier,
      this.description,
      this.address,
      this.price,
      this.pricingType,
      this.dateCreation,
      this.dateDebut,
      this.dateFin,
      this.nbHourPerDay,
      this.orderStatus,
      this.creator,
      this.employee,
      this.interestsCount,
      this.myInterest
      });


  factory OfferModel.fromJson(Map<String,dynamic> json,String id){
    return OfferModel(
      offerId: id,
      metier:json['metier'],
      description: json['description'],
      address: json['address'],
      price: double.parse(json['price'].toString()),
      pricingType: json['pricingType'],
      dateCreation: (json['dateCreation'] as Timestamp).toDate(),
      dateDebut: (json['dateDebut'] as Timestamp).toDate(),
      dateFin:(json['dateFin'] as Timestamp).toDate(),
      nbHourPerDay: json['nbHoursPerDay'],
      orderStatus: json['orderStatus'],
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'metier':metier,
      'description':description,
      'address':address,
      'price':price,
      'pricingType':pricingType,
      'dateCreation':Timestamp.now(),
      'dateDebut':dateDebut,
      'dateFin':dateFin,
      'nbHoursPerDay':nbHourPerDay,
      'orderStatus':orderStatus,
      'creatorId':creator?.uid,
      'employeeId':employee?.uid,
    };
  }

  static OfferModel toOfferModel(OfferEntity offerEntity){
    return OfferModel(
      metier: offerEntity.metier,
      description: offerEntity.description,
      address: offerEntity.address,
      price: offerEntity.price,
      nbHourPerDay: offerEntity.nbHourPerDay,
      dateDebut: offerEntity.dateDebut,
      dateFin: offerEntity.dateFin,
      offerId: offerEntity.offerId,
      dateCreation: offerEntity.dateCreation,
      creator:offerEntity.creator!=null?UserModel.toUserModel(offerEntity.creator!):null,
      employee: offerEntity.employee!=null?UserModel.toUserModel(offerEntity.employee!):null,
      orderStatus: offerEntity.orderStatus?.orderStatusString,
      pricingType: offerEntity.pricingType?.pricingTypesString
    );

  }

  OfferEntity toOfferEntity(){
    return OfferEntity(
      employee: employee?.toUserEntity(),
      creator: creator?.toUserEntity(),
      offerId: offerId,
      dateCreation: dateCreation,
      dateDebut: dateDebut,
      dateFin: dateFin,
      pricingType: pricingType?.pricingType,
      orderStatus: orderStatus?.orderStatus,
      nbHourPerDay: nbHourPerDay,
      price: price,
      metier: metier,
      address: address,
      description: description,
      countInterests: interestsCount,
      interestEntity: myInterest?.toInterestEntity()
    );
  }

  OfferModel copyWith({int? interestsCount,InterestModel? interestModel,UserModel? employee,UserModel? creator}){
    return OfferModel(
      employee: employee ?? this.employee,
      interestsCount: interestsCount ?? this.interestsCount,
      description: description,
      address: address,
      metier: metier,
      price: price,
      nbHourPerDay: nbHourPerDay,
      dateFin: dateFin,
      dateDebut: dateDebut,
      creator: creator ?? this.creator,
      orderStatus: orderStatus,
      pricingType: pricingType,
      dateCreation: dateCreation,
      offerId: offerId,
      myInterest: interestModel ?? myInterest
    );
  }

  Map<String,dynamic> jsonForNotInterested(){
    return {
      'offerId':offerId
    };
  }

}