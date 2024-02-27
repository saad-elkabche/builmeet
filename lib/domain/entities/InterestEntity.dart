


import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';

class InterestEntity {
  InterestsStatus? interestStatus;
  double? interestPrice;
  UserEntity? user;
  OfferEntity? offer;
  DateTime? dateCreation;

  InterestEntity(
      {this.interestStatus,this.dateCreation, this.interestPrice, this.user, this.offer});

  InterestEntity copyWith({OfferEntity? offerEntity}){
    return InterestEntity(
      user: this.user,
      offer: offerEntity ?? this.offer,
      interestPrice: interestPrice,
      interestStatus: interestStatus,
      dateCreation: dateCreation,
    );
  }

}