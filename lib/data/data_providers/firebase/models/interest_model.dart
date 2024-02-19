import 'package:builmeet/core/extenssions/interests_status_extension.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';



class InterestModel{
  String? interestStatus;
  double? interestPrice;
  UserModel? user;
  OfferModel? offer;

  InterestModel(
      {this.interestStatus, this.interestPrice, this.user, this.offer});

  factory InterestModel.fromJson(Map<String,dynamic> json){
    return InterestModel(
      interestPrice: double.parse(json['interestPrice'].toString()),
      interestStatus: json['interestStatus'],
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'interestPrice':interestPrice,
      'interestStatus':interestStatus,
      'idOffer':offer?.offerId,
      'idEmployee':user?.uid,
    };
  }

  static InterestModel toInterestModel(InterestEntity interestEntity){
    return InterestModel(
      interestPrice: interestEntity.interestPrice,
      interestStatus: interestEntity.interestStatus?.interestStatusString,
      user: UserModel.toUserModel(interestEntity.user!),
      //offer: OfferModel.toOfferModel()
    );
  }




}