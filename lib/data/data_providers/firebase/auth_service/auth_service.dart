




import 'dart:io';

import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/exceptions/email_already_in_use.dart';
import 'package:builmeet/domain/exceptions/no_user_found_for_that_email.dart';
import 'package:builmeet/domain/exceptions/weak_pass_exception.dart';
import 'package:builmeet/domain/exceptions/wrong_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService{

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;


  final String userCollectionName='users';


  AuthService({required this.firebaseStorage,required this.firebaseAuth,required this.firebaseFirestore});



  Future<void> register(UserModel userModel)async{
    try{
      UserCredential userCredential=await firebaseAuth.
      createUserWithEmailAndPassword(
          email: userModel.adressEmail!,
          password: userModel.password!);

      String userId=userCredential.user!.uid;


      if(userModel.imgProfile!=null){
        String? profileUrl=await uploadFile(userModel.imgProfile!, 'profiles','$userId.jpg');
        userModel=userModel.copyWith(profilePicUrl: profileUrl);
      }

      await firebaseFirestore.collection(userCollectionName)
          .doc(userId)
          .set(userModel.jsonForCreateAccount());

    }on FirebaseAuthException catch(ex){
      if(ex.code=='weak-password'){
        throw WeakPassException();
      }else if(ex.code=='email-already-in-use'){
        throw EmailAlreadyInUse();
      }
    }

  }



  Future<String?> uploadFile(File file,String folder,String fileName)async{
    Reference ref = firebaseStorage.ref(folder).child(fileName);
    await ref.putFile(file);
    String url=await ref.getDownloadURL();
    return url;
  }



  Future<UserModel> login(UserModel user)async{
    try{
      UserCredential credential=await firebaseAuth.signInWithEmailAndPassword(
          email: user.adressEmail!,
          password: user.password!);

      UserModel userModel=await getUser(credential.user!.uid);
      return userModel;
    }on FirebaseAuthException catch(ex){
      if(ex.code=='user-not-found' ||ex.code=='wrong-password' ||ex.code=='invalid-credential'){
        throw InvalidCredential();
      }
      rethrow;
    }
  }


  Future<UserModel> getUser(String id)async{
    UserModel userModel=await firebaseFirestore.collection(userCollectionName)
        .doc(id)
        .get()
        .then(
            (document) => UserModel.fromJson(document.data()!,id)
    );

    return userModel;
  }

  Future<UserModel> getCurrentUser()async{
    String uid=firebaseAuth.currentUser!.uid;
    UserModel userModel=await getUser(uid);
    return userModel;
  }

  Future<void> signOut()async{
    await firebaseAuth.signOut();
  }




}