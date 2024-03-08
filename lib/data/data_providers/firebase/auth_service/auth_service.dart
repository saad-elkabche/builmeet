




import 'dart:io';

import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/exceptions/email_already_in_use.dart';
import 'package:builmeet/domain/exceptions/no_user_found_for_that_email.dart';
import 'package:builmeet/domain/exceptions/requires_recent_login_exception.dart';
import 'package:builmeet/domain/exceptions/weak_pass_exception.dart';
import 'package:builmeet/domain/exceptions/wrong_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService{

  FirebaseAuth firebaseAuth;

  final String userCollectionName='users';


  AuthService({required this.firebaseAuth});



  Future<UserCredential> register(String email,String password)async{
    try{
      UserCredential userCredential=await firebaseAuth.
      createUserWithEmailAndPassword(
          email: email,
          password: password);
      return userCredential;
    }on FirebaseAuthException catch(ex){
      if(ex.code=='weak-password'){
        throw WeakPassException();
      }else if(ex.code=='email-already-in-use'){
        throw EmailAlreadyInUse();
      }
      rethrow;
    }

  }
  Future<UserCredential> login(String email,String password)async{
    try{
      UserCredential credential=await firebaseAuth.signInWithEmailAndPassword(
          email:email,
          password: password);
      return credential;
    }on FirebaseAuthException catch(ex){
      if(ex.code=='user-not-found' ||ex.code=='wrong-password' ||ex.code=='invalid-credential'){
        throw InvalidCredential();
      }
      rethrow;
    }
  }
  Future<void> signOut()async{
    await firebaseAuth.signOut();
  }
  
  Future<void> updatePassword(String newPassword)async{
    try{
      User user = firebaseAuth.currentUser!;
      await user.updatePassword(newPassword);
    }on FirebaseAuthException catch(ex){
      if( ex.code=='requires-recent-login'){
        throw RequiresRecentLoginException();
      }
      rethrow;
    }
  }
  Future<void> updateEmail(String newEmail)async{
    try{
      User user = firebaseAuth.currentUser!;
      await user.updateEmail(newEmail);
    }on FirebaseAuthException catch(ex){
      if( ex.code=='requires-recent-login'){
        throw RequiresRecentLoginException();
      }
      rethrow;
    }
  }

  User getCurrentUser(){
    User user=firebaseAuth.currentUser!;
    return user;
  }

}