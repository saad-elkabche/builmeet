


import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';

class InterestEntity {
  InterestsStatus? interestStatus;
  double? interestPrice;
  UserEntity? user;
  OfferEntity? offer;

  InterestEntity(
      {this.interestStatus, this.interestPrice, this.user, this.offer});
}