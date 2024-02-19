



import 'package:builmeet/data/data_providers/firebase/auth_service/auth_service.dart';
import 'package:builmeet/data/data_providers/firebase/db_service/db_service.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';


abstract class FirebaseData{
  Future<void> register(UserModel user);
  Future<UserModel> login(UserModel user);
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Future<void> createOffer(OfferModel offerModel);
}


class FirebaseDataIml extends FirebaseData{

  AuthService authService;
  DBService dbService;


  FirebaseDataIml(this.authService,this.dbService);

  @override
  Future<UserModel> login(UserModel user)async {
    UserModel userResponse=await authService.login(user);
    return userResponse;
  }

  @override
  Future<void> register(UserModel user) async{
    await authService.register(user);
  }

  @override
  Future<UserModel> getCurrentUser() async{
    UserModel userModel=await authService.getCurrentUser();
    return userModel;
  }

  @override
  Future<void> signOut() async{
    await authService.signOut();
  }

  @override
  Future<void> createOffer(OfferModel offerModel) async{
    await dbService.createOffer(offerModel);
  }





}