





import 'package:builmeet/data/data_providers/firebase/auth_service/auth_service.dart';
import 'package:builmeet/data/data_providers/firebase/db_service/db_service.dart';
import 'package:builmeet/data/data_providers/firebase/models/interest_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/data/data_providers/firebase/storage_service/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


abstract class FirebaseData{
  Future<void> register(UserModel user);
  Future<UserModel> login(UserModel user);
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Future<void> createOffer(OfferModel offerModel);
  Future<List<OfferModel>> getOfferForClient();
  Future<List<OfferModel>> getOfferForEmployee();

  Future<UserModel> updateEmail(UserModel user);
  Future<UserModel> updateName(UserModel user);
  Future<UserModel> updatePassword(UserModel user);
  Future<UserModel> updateProfilImg(UserModel user);


  Future<UserModel> setEmployeeData(UserModel user);


  Future<InterestModel> setEmployeeIntersting(InterestModel interestModel);
  Future<void> setNotInterested(OfferModel offerModel);

  Future<List<InterestModel>> getInterests(OfferModel offerModel);


  Future<InterestModel> acceptInterest(InterestModel interestModel);
  Future<InterestModel> refuseInterest(InterestModel interestModel);


  Future<List<OfferModel>> getAllOffersForClients();


  Future<OfferModel> finishOffer(OfferModel offerModel);
  Future<void> clientRateOffer(OfferModel offerModel);
  Future<void> employeeRateOffer(OfferModel offerModel);



  Future<List<InterestModel>> getAllInterestForEmployee();

  Future<void> clientStopOffer(OfferModel offerModel);

  Future<UserModel> removeDocument(String url);

  //Future<UserModel> updateEmployeeInfos(UserModel userModel);



}


class FirebaseDataIml extends FirebaseData{

  AuthService authService;
  DBService dbService;
  StorageService storageService;


  FirebaseDataIml(this.authService,this.dbService,this.storageService);

  @override
  Future<UserModel> login(UserModel user)async {
  UserCredential credential=await authService.login(user.adressEmail!,user.password!);
  user=user.copyWith(uid: credential.user!.uid);
  UserModel userModel=await dbService.updateUserEmail(user);
  return userModel;
  }

  @override
  Future<void> register(UserModel user) async{
    UserCredential credential=await authService.register(user.adressEmail!,user.password!);
    String? profileUrl;
    if(user.imgProfile!=null){
      profileUrl=await storageService.uploadFile(user.imgProfile!, StorageService.profilesFolderName, '${credential.user!.uid}.jpg');
    }
    user=user.copyWith(profilePicUrl: profileUrl,uid: credential.user!.uid);
    dbService.registerNewUser(user);
  }

  @override
  Future<UserModel> getCurrentUser() async{
    User user=authService.getCurrentUser();
    UserModel userModel=await dbService.getUser(user.uid);
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

  @override
  Future<List<OfferModel>> getOfferForClient()async {
    List<OfferModel> offers=await dbService.getOffersForClient();
    return offers;
  }

  @override
  Future<List<OfferModel>> getOfferForEmployee() async{
    String emplyeeId=authService.getCurrentUser().uid;
    List<OfferModel> offers=await dbService.getOffersForEmployee(emplyeeId);
    return offers;
  }

  @override
  Future<UserModel> updateEmail(UserModel user) async{
    await authService.updateEmail(user.adressEmail!);
    return user;
  }

  @override
  Future<UserModel> updateName(UserModel user) async{
    UserModel userModel=await dbService.updateUserName(user);
    return userModel;
  }

  @override
  Future<UserModel> updatePassword(UserModel user) async{
    await authService.updatePassword(user.password!);
    return user;
  }

  @override
  Future<UserModel> updateProfilImg(UserModel user) async{
    if(user.imgProfile!=null){
      String? imgProfileUrl;
      imgProfileUrl=await storageService.uploadFile(user.imgProfile!, StorageService.profilesFolderName, "${user.uid}.jpg");
      user =user.copyWith(profilePicUrl: imgProfileUrl);
      UserModel userModel=await dbService.updateUserProfileUrl(user);
      return userModel;
    }
    return user;
  }

  @override
  Future<UserModel> setEmployeeData(UserModel user) async{
    String folder="${StorageService.documentsFolderName}/${authService.getCurrentUser().uid}";
    List<String> documentUrls=user.documentUrls ?? [];
    if(user.documents?.isNotEmpty ?? false){
      List<String> urls=await storageService.uploadFiles(user.documents!,folder );
      documentUrls.addAll(urls);
    }
    user=user.copyWith(documentUrls: documentUrls);
    UserModel userModelRes=await dbService.setEmployeeData(user);
    return userModelRes;
  }

  @override
  Future<InterestModel> setEmployeeIntersting(InterestModel interestModel) async{
    InterestModel interestModelRes=await dbService.setEmployeeIntersted(interestModel);
    return interestModelRes;
  }

  @override
  Future<void> setNotInterested(OfferModel offerModel) async{
    String myId=authService.getCurrentUser().uid;
    await dbService.setEmployeeNotIntersted(offerModel, myId);
  }

  @override
  Future<List<InterestModel>> getInterests(OfferModel offerModel) async{
    List<InterestModel> interests=await dbService.getInterets(offerModel);
    return interests;
  }

  @override
  Future<InterestModel> acceptInterest(InterestModel interestModel) async{
    InterestModel interestModelRes = await dbService.acceptInterest(interestModel);
    return interestModelRes;
  }

  @override
  Future<InterestModel> refuseInterest(InterestModel interestModel) async{
    InterestModel interestModelRes=await dbService.refuseInterest(interestModel);
    return interestModelRes;
  }

  @override
  Future<List<OfferModel>> getAllOffersForClients() async{

    String myId=authService.getCurrentUser().uid;
    List<OfferModel> offers=await dbService.getAllOffersForClient(myId);
    return offers;
  }

  @override
  Future<void> clientRateOffer(OfferModel offerModel) async{
    await dbService.clientRateOffer(offerModel);
  }

  @override
  Future<void> employeeRateOffer(OfferModel offerModel)async{
    await dbService.employeeRateOffer(offerModel);
  }

  @override
  Future<OfferModel> finishOffer(OfferModel offerModel) async{
    OfferModel offerModelRes =await dbService.finishOffer(offerModel);
    return offerModelRes;
  }

  @override
  Future<List<InterestModel>> getAllInterestForEmployee() async{
    String employeeId=authService.getCurrentUser().uid;
    List<InterestModel> interests=await dbService.getAllInterestsForEmployee(employeeId);
    return interests;
  }

  @override
  Future<void> clientStopOffer(OfferModel offerModel) async{
    await dbService.clientStopOffer(offerModel);
  }

  @override
  Future<UserModel> removeDocument(String url)async {
    String uid=authService.getCurrentUser().uid;
    UserModel userModel=await dbService.getUser(uid);
    List<String> newUrls=userModel.documentUrls ?? [];
    newUrls.remove(url);
    userModel=userModel.copyWith(documentUrls: newUrls);
    await Future.wait(
      [
        storageService.deleteImageByUrl(url),
        dbService.updateUserDocuments(userModel),
      ]
    );
    UserModel userModelRes=await dbService.getUser(uid);
    return userModelRes;
  }

/*  @override
  Future<UserModel> updateEmployeeInfos(UserModel user) async{
    String uid=authService.getCurrentUser().uid;
    List<String> urls=user.documentUrls ?? [];
    if(user.documents?.isNotEmpty ?? false){
      List<String> newDocumentsUrls=await storageService.uploadFiles(user.documents!, '${StorageService.documentsFolderName}/${uid}');
      urls.addAll(newDocumentsUrls);
    }
    user=user.copyWith(documentUrls: urls);
    UserModel userModelRes=await setEmployeeData(user);
    return userModelRes;
  }*/






}