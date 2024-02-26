


import 'dart:io';
import 'dart:ui';

import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/order_status_extension.dart';
import 'package:builmeet/data/data_providers/firebase/models/interest_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class DBService{

  FirebaseFirestore firebaseFirestore;

  final String offersCollectionName='offers';
  final String interestsCollectionName='interests';
  final String userCollectionName='users';
  final String notInterstedCollectionName='notInterested';


  DBService({
    required this.firebaseFirestore,
   });


  Future<void> createOffer(OfferModel offerModel)async{
    await firebaseFirestore.collection(offersCollectionName)
        .add(offerModel.toJson());
  }


  Future<void> registerNewUser(UserModel userModel)async{
    await firebaseFirestore.collection(userCollectionName)
        .doc(userModel.uid)
        .set(userModel.jsonForCreateAccount());
  }
  Future<UserModel> updateUserEmail(UserModel userModel)async{
   await firebaseFirestore.collection(userCollectionName)
        .doc(userModel.uid)
        .update(userModel.jsonForUpdatingEmail());
   UserModel newUser=await getUser(userModel.uid!);
   return newUser;
  }
  Future<UserModel> updateUserName(UserModel userModel)async{
    await firebaseFirestore.collection(userCollectionName)
        .doc(userModel.uid)
        .update(userModel.jsonForUpdatingName());
    UserModel newUser=await getUser(userModel.uid!);
    return newUser;
  }
  Future<UserModel> updateUserProfileUrl(UserModel userModel)async{
    await firebaseFirestore.collection(userCollectionName)
        .doc(userModel.uid)
        .update(userModel.jsonForUpdatingprofileUrl());
    UserModel newUser=await getUser(userModel.uid!);
    return newUser;
  }
  Future<UserModel> setEmployeeData(UserModel userModel)async{
    await firebaseFirestore.collection(userCollectionName)
        .doc(userModel.uid)
        .update(userModel.jsonEmployeeData());
    UserModel userModelRes=await getUser(userModel.uid!);
    return userModelRes;
  }

  Future<List<OfferModel>> getOffersForClient()async{
    String myId=FirebaseAuth.instance.currentUser!.uid;
    List<OfferModel> offers=await firebaseFirestore.collection(offersCollectionName)
    .where('creatorId',isEqualTo: myId)
    .where(
      Filter.or(
        Filter('orderStatus',isEqualTo: OrderStatus.pending.orderStatusString),
        Filter('orderStatus',isEqualTo: OrderStatus.active.orderStatusString)
      )
    ).orderBy('dateCreation',descending: true)
    .get()
    .then(
            (value)async{

              if(value.docs.isNotEmpty){
                List<OfferModel> offers=[];
                for(var doc in value.docs){
                  OfferModel offerModel=OfferModel.fromJson(doc.data(), doc.id);

                  var results=await Future.wait(
                    [
                      getUser(doc.data()['creatorId']),
                      getInterestsCountOfOffer(doc.id),
                      if(doc.data()['employeeId']!=null)
                        getUser(doc.data()['employeeId'])
                    ]
                  );
                  UserModel? creator=results.elementAt(0) as UserModel?;
                  int? count=results.elementAt(1) as int?;
                  print('================from retriever============$count');
                  UserModel? employee=results.length==3?results.elementAt(2) as UserModel?:null ;

                  offerModel=offerModel.copyWith(creator: creator,interestsCount: count,employee: employee);

                  offers.add(offerModel);
                }
                return offers;
              }
              return [];
            }
    );
    return offers;
                                
  }
  /*Filter.and(
             Filter('creatorId',isNotEqualTo: employeeId),
             Filter('orderStatus',isEqualTo:OrderStatus.pending.orderStatusString)
          )*/
  
  Future<List<OfferModel>> getOffersForEmployee(String employeeId)async{

    List<OfferModel> offers=await firebaseFirestore.collection(offersCollectionName)
        //.where('creatorId',isNotEqualTo: employeeId)
        .where('orderStatus',isEqualTo:OrderStatus.pending.orderStatusString)
        .orderBy('dateCreation',descending: true)
        .get()
        .then(
            (value)async{

          if(value.docs.isNotEmpty){
            List<OfferModel> offers=[];
            for(var doc in value.docs){
              if(doc.data()['creatorId']!=employeeId){
                OfferModel offerModel=OfferModel.fromJson(doc.data(), doc.id);
                UserModel? creator=await getUser(doc.data()['creatorId']);
                InterestModel? myInterest=await getInterset(doc.id, employeeId);
                offerModel=offerModel.copyWith(creator: creator,interestModel: myInterest);
                offers.add(offerModel);
              }
            }
            return offers;
          }
          return [];
        }
    );
    return offers;
  }



  Future<int?> getInterestsCountOfOffer(String offerId)async{
    int? count = await firebaseFirestore.collection(interestsCollectionName)
        .where('idOffer',isEqualTo: offerId)
        .count()
        .get()
        .then((value) =>value.count );
    print("===========count=================$count");
    return count;
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

  Future<InterestModel?> getInterset(String offerId,String employeeId)async{
    InterestModel? interestModel=await firebaseFirestore.collection(interestsCollectionName)
        .where(
      Filter.and(
         Filter('idOffer',isEqualTo: offerId),
         Filter('idEmployee',isEqualTo: employeeId)
      )
    ).get()
      .then(
            (value) {
              if(value.docs.isNotEmpty){
                return InterestModel.fromJson(value.docs.elementAt(0).data());
              }
              return null;
            }
    );
    return interestModel;
  }


  Future<InterestModel> setEmployeeIntersted(InterestModel interestModel)async{
    await firebaseFirestore.collection(interestsCollectionName)
        .add(interestModel.toJson());
    InterestModel interestModelRes=(await getInterset(interestModel.offer!.offerId!,interestModel.user!.uid!))!;
    return interestModelRes;
  }


  Future<void> setEmployeeNotIntersted(OfferModel offerModel,String myId)async{
    await firebaseFirestore.collection(userCollectionName)
        .doc(myId)
        .collection(notInterstedCollectionName)
        .add(offerModel.jsonForNotInterested());
  }


  Future<List<InterestModel>> getInterets(OfferModel offerModel)async{
    List<InterestModel> interests=await firebaseFirestore.collection(interestsCollectionName)
        .where('idOffer',isEqualTo:offerModel.offerId)
        .orderBy('dateCreation')
        .get()
        .then(
        (value)async{
          if(value.docs.isNotEmpty){
            List<InterestModel> interests=[];
            for(var doc in value.docs){
              InterestModel interestModel=InterestModel.fromJson(doc.data());
              UserModel userModel=await getUser(doc.data()['idEmployee']);
              interestModel=interestModel.copyWith(offer: offerModel,user: userModel);
              interests.add(interestModel);
            }
            return interests;
          }
          return [];
        }
    );
    return interests;
  }












}