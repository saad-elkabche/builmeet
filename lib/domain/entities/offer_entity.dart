



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
  InterestEntity? interestEntity;
  int? countInterests;
  int? clientRate;
  int? employeeRate;

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
    this.interestEntity,
    this.clientRate,
    this.employeeRate,
    this.countInterests});

   set setInterest(InterestEntity interestEntity){
    this.interestEntity=interestEntity;
  }

  OfferEntity copyWith({InterestEntity? interestEntity,double? price,int? clientRate,int? employeeRate,UserEntity? employee}){
    return OfferEntity(
    offerId: this.offerId,
    metier: this.metier,
    description: this.description,
    address: this.address,
    price: price ?? this.price,
    pricingType: this.pricingType,
    dateCreation: this.dateCreation,
    dateDebut: this.dateDebut,
    dateFin: this.dateFin,
    nbHourPerDay: this.nbHourPerDay,
    orderStatus: this.orderStatus,
    creator: this.creator,
    employee:employee ?? this.employee,
    interestEntity:interestEntity ?? this.interestEntity,
    countInterests: this.countInterests,
    clientRate: clientRate ?? this.clientRate,
    employeeRate: employeeRate ?? this.employeeRate
    );
  }

  @override
  String toString() {
    return "id:$offerId metier: $metier addrss: $address description $description price $price nbHour $nbHourPerDay orderStatus $orderStatus";
  }
}