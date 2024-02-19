



import 'package:builmeet/data/data_providers/firebase/auth_service/auth_service.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';


abstract class FirebaseData{
  Future<void> register(UserModel user);
  Future<UserModel> login(UserModel user);
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
}


class FirebaseDataIml extends FirebaseData{

  AuthService authService;


  FirebaseDataIml(this.authService);

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





}