



import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';

abstract class Repository{


  Future<void> register(UserEntity userEntity);
  Future<UserEntity> login(UserEntity userEntity);
  Future<UserEntity> getCurrentUser();
  Future<void> signOut();
  Future<void> createOffer(OfferEntity offerEntity);


}