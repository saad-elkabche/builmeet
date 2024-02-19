



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
  List<InterestModel>? interests;

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
      this.interests});


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


}