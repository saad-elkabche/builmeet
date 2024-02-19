



import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';

class OfferEntity {
  String? offerId;
  String? metier;
  String? description;
  String? address;
  double? price;
  PricingTypes? pricingType;
  DateTime? dateCreation;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? nbHourPerDay;
  OrderStatus? orderStatus;
  UserEntity? creator;
  UserEntity? employee;
  List<InterestEntity>? interests;

  OfferEntity({
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
}