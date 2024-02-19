






import 'package:builmeet/data/data_providers/firebase/firebase_data.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';

class RepositoryIml extends Repository{

  FirebaseData firebaseData;

  RepositoryIml({required this.firebaseData});


  @override
  Future<UserEntity> login(UserEntity userEntity) async{
    UserModel userModel=UserModel.toUserModel(userEntity);
    UserModel userResponse=await firebaseData.login(userModel);
    return userResponse.toUserEntity();
  }

  @override
  Future<void> register(UserEntity userEntity) async{
      UserModel userModel=UserModel.toUserModel(userEntity);
      await firebaseData.register(userModel);
  }

  @override
  Future<UserEntity> getCurrentUser()async {
    UserModel userModel=await firebaseData.getCurrentUser();
    return userModel.toUserEntity();
  }

  @override
  Future<void> signOut() async{
    await firebaseData.signOut();
  }

  @override
  Future<void> createOffer(OfferEntity offerEntity) async{
    OfferModel offerModel=OfferModel.toOfferModel(offerEntity);
    await firebaseData.createOffer(offerModel);
  }


}