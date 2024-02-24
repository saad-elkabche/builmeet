


import 'dart:ui';

import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/order_status_extension.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DBService{

  FirebaseFirestore firebaseFirestore;

  final String offersCollectionName='offers';
  final String interestsCollectionName='interests';
  final String userCollectionName='users';


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
                  UserModel? employee=results.length==3?results.elementAt(2) as UserModel?:null ;

                  offerModel=offerModel.copyWith(creator: creator,interestCount: count,employee: employee);

                  offers.add(offerModel);
                }
                return offers;
              }
              return [];
            }
    );
    return offers;
                                
  }
  
  Future<List<OfferModel>> getOffersForEmployee()async{
    List<OfferModel> offers=await firebaseFirestore.collection(offersCollectionName)
        .where('orderStatus',isEqualTo: OrderStatus.pending.orderStatusString)
        .get()
        .then(
            (value)async{

          if(value.docs.isNotEmpty){
            List<OfferModel> offers=[];
            for(var doc in value.docs){
              OfferModel offerModel=OfferModel.fromJson(doc.data(), doc.id);
              UserModel? creator=await getUser(doc.data()['creatorId']);
              offerModel=offerModel.copyWith(creator: creator);
              offers.add(offerModel);
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
        .where('offerId',isEqualTo: offerId)
        .count()
        .get()
        .then((value) =>value.count );
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










}