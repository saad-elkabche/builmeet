



import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';

abstract class Repository{


  Future<void> register(UserEntity userEntity);
  Future<UserEntity> login(UserEntity userEntity);
  Future<UserEntity> getCurrentUser();
  Future<void> signOut();
  Future<void> createOffer(OfferEntity offerEntity);

  Future<List<OfferEntity>> getOfferForClient();
  Future<List<OfferEntity>> getOffersForEmployee();

  Future<UserEntity> updateName(UserEntity userEntity);
  Future<UserEntity> updateEmail(UserEntity userEntity);
  Future<UserEntity> updatePassword(UserEntity userEntity);
  Future<UserEntity> updateProfileImg(UserEntity userEntity);
  Future<UserEntity> setEmployeeData(UserEntity userEntity);



}