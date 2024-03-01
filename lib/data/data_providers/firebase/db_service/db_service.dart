





import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/interests_status_extension.dart';
import 'package:builmeet/core/extenssions/order_status_extension.dart';
import 'package:builmeet/data/data_providers/firebase/models/interest_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



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

  Future<List<String>> getOffersEmployeeNotInterestedWith(String employeeId)async{
    List<String> offerIds=await firebaseFirestore.collection(userCollectionName)
        .doc(employeeId)
        .get()
        .then(
            (value) async{
              List<String> offerIds=await value.reference
                  .collection(notInterstedCollectionName)
                  .get()
                  .then(
                  (value){
                    if(value.docs.isNotEmpty){
                      List<String> ids=[];
                      for(var doc in value.docs){
                        String offerId=doc.data()['offerId'];
                        ids.add(offerId);
                      }
                      return ids;
                    }
                    return [];
                  }
              );
              return offerIds;
            }
    );
    return offerIds;
  }
  
  Future<List<OfferModel>> getOffersForEmployee(String employeeId)async{

    List<String> offersNotIntersted=await getOffersEmployeeNotInterestedWith(employeeId);

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
              if(doc.data()['creatorId']!=employeeId  && !offersNotIntersted.contains(doc.id) ){
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
            (value) async{
              if(value.docs.isNotEmpty){
                var doc=value.docs.elementAt(0);
                InterestModel interestModel= InterestModel.fromJson(doc.data());
                UserModel userModel=await getUser(doc.data()['idEmployee']);
                OfferModel offerModel=await getOffer(doc.data()['idOffer']);
                interestModel=interestModel.copyWith(offer: offerModel,user: userModel);
                return interestModel;
              }
              return null;
            }
    );
    return interestModel;
  }
  Future<OfferModel> getOffer(String offerId)async{
    OfferModel offerModel= await firebaseFirestore.collection(offersCollectionName)
        .doc(offerId)
        .get()
        .then(
            (value) async{
          OfferModel offerModel=OfferModel.fromJson(value.data()!, value.id);
          UserModel? creator=await getUser(value.data()!['creatorId']);
          UserModel? employee;
          if(value.data()!['employeeId']!=null){
             employee=await getUser(value.data()!['employeeId']);
          }

          offerModel=offerModel.copyWith(creator: creator,employee: employee);
          return offerModel;
        }
    );
    return offerModel;
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


  Future<InterestModel> acceptInterest(InterestModel interestModel)async{
    await Future.wait(
      [
         updateOfferStatus(interestModel.offer!,OrderStatus.active.orderStatusString),
         updateInterestState(interestModel,InterestsStatus.accepted.interestStatusString),
         updateOtherInterestStatus(interestModel,InterestsStatus.taken.interestStatusString),
      ]
    );
    InterestModel interestModelRes=(await getInterset(interestModel.offer!.offerId!, interestModel.user!.uid!))!;
    return interestModelRes;
  }

  Future<void> updateOfferStatus(OfferModel offer,String newStatus) async{
    offer=offer.copyWith(orderStatus: newStatus);
    await firebaseFirestore.collection(offersCollectionName)
        .doc(offer.offerId)
        .get()
        .then(
            (value)async{
              value.reference.update(offer.jsonForAcceptOrder());
            }
    );
  }


  Future<void> updateOtherInterestStatus(InterestModel interestModel,String newStatus) async{


    await firebaseFirestore.collection(interestsCollectionName)
    .where('idOffer',isEqualTo:interestModel.offer!.offerId)
    .get()
    .then(
            (value)async{

              if(value.docs.isNotEmpty){

                for(var doc in value.docs){

                  if( doc.data()['idEmployee'] != interestModel.user!.uid  ){

                    interestModel=interestModel.copyWith(insterestStatus: newStatus);
                    await doc.reference.update(interestModel.jsonForUpdateStatus());

                  }

                }

              }

            }
    );
  }

  Future<void> updateInterestState(InterestModel interestModel, String newStatus) async{
    interestModel=interestModel.copyWith(insterestStatus: newStatus);
    await firebaseFirestore.collection(interestsCollectionName)
    .where(
        Filter.and(
            Filter('idOffer',isEqualTo: interestModel.offer!.offerId),
            Filter('idEmployee',isEqualTo: interestModel.user!.uid)
        )
    ).get()
    .then(
            (value)async{
              if(value.docs.isNotEmpty){
                var doc=value.docs.elementAt(0);
                await doc.reference.update(interestModel.jsonForUpdateStatus());
              }
            }
    );
  }


  Future<InterestModel> refuseInterest(InterestModel interestModel)async{
    interestModel =interestModel.copyWith(insterestStatus: InterestsStatus.refused.interestStatusString);
    await firebaseFirestore.collection(interestsCollectionName)
        .where(
        Filter.and(
            Filter('idOffer',isEqualTo: interestModel.offer!.offerId),
            Filter('idEmployee',isEqualTo: interestModel.user!.uid)
        )
    ).get()
        .then(
            (value)async{
              if(value.docs.isNotEmpty){
                var doc=value.docs.elementAt(0);
                await doc.reference.update(interestModel.jsonForUpdateStatus());
              }
            }
    );
    InterestModel interestModelRes=(await getInterset(interestModel.offer!.offerId!, interestModel.user!.uid!))!;
    return interestModelRes;
  }



  Future<List<OfferModel>> getAllOffersForClient(String creatorId)async{
    List<OfferModel> offers=await firebaseFirestore.collection(offersCollectionName)
        .where('creatorId',isEqualTo: creatorId)
        .orderBy('dateCreation',descending: true)
        .get()
        .then(
            (value)async{

              if(value.docs.isNotEmpty){
                List<OfferModel> offers=[];
                for(var doc in value.docs){
                  OfferModel offerModel=OfferModel.fromJson(doc.data(), doc.id);
                  UserModel? creator=await getUser(doc.data()['creatorId']);
                  UserModel? employee;
                  if(doc.data()['employeeId']!=null){
                    employee=await getUser(doc.data()['employeeId']);
                  }
                  offerModel=offerModel.copyWith(creator: creator,employee: employee);

                  offers.add(offerModel);
                }
                return offers;
              }
              return [];
            }
    );
    return offers;

  }


  Future<OfferModel> finishOffer(OfferModel offerModel)async{
    offerModel=offerModel.copyWith(orderStatus: OrderStatus.finished.orderStatusString);

    await firebaseFirestore.collection(offersCollectionName)
        .doc(offerModel.offerId)
        .get()
        .then(
            (value) async{
              await value.reference.update(offerModel.jsonForUpdateStatus());
          }
    );

    OfferModel offerModelRes =await getOffer(offerModel.offerId!);


    return offerModelRes;
  }

  Future<void> clientRateOffer(OfferModel offerModel)async{
    double newRate=(offerModel.clientRate!).toDouble();
    String employeeId=offerModel.employee!.uid!;
    await Future.wait(
      [
        rateOffer(offerModel),
        rateUser(employeeId, newRate)
      ]
    );
  }

  Future<void> rateOffer(OfferModel offerModel)async{
    await firebaseFirestore.collection(offersCollectionName)
        .doc(offerModel.offerId)
        .get()
        .then(
            (value)async{
          await value.reference.update(offerModel.jsonForUpdateRates());
        }
    );
  }
  Future<void> rateUser(String uid,double newRate)async{
    UserModel userModel=await getUser(uid);

    newRate+=userModel.rate!;
    int nbRates=userModel.nbRates!+1;

    userModel=userModel.copyWith(nbRates: nbRates,rate: newRate);
    await firebaseFirestore.collection(userCollectionName)
    .doc(uid)
    .get()
    .then(
            (value)async {
              await value.reference.update(userModel.jsonForUpdatingRate());
            }
    );
  }

  Future<void> employeeRateOffer(OfferModel offerModel)async{
    double newRate=(offerModel.employeeRate)!.toDouble();
    String creatorUid=offerModel.creator!.uid!;
    await Future.wait(
        [
          rateOffer(offerModel),
          rateUser(creatorUid, newRate)
        ]
    );

  }

  Future<List<InterestModel>> getAllInterestsForEmployee(String employeeId)async{
    List<InterestModel> interests=await firebaseFirestore.collection(interestsCollectionName)
        .where('idEmployee',isEqualTo: employeeId)
        .orderBy('dateCreation',descending: true)
        .get()
        .then(
            (value)async{

              if(value.docs.isNotEmpty){
                List<InterestModel> interests=[];
                for(var doc in value.docs){
                  var results=await Future.wait(
                    [
                      getOffer(doc.data()['idOffer']),
                      getUser(doc.data()['idEmployee']),
                    ]
                  );
                  
                  OfferModel offer=results[0] as OfferModel;
                  UserModel employee=results[1] as UserModel;

                  InterestModel interestModel=InterestModel.fromJson(doc.data());
                  interestModel=interestModel.copyWith(offer: offer,user: employee);
                  interests.add(interestModel);
                }
                return interests;
              }
              return [];
            }
    );
    return interests;
  }

  Future<void> clientStopOffer(OfferModel offerModel)async{
    offerModel=offerModel.copyWith(orderStatus: OrderStatus.stopped.orderStatusString);
    await firebaseFirestore.collection(offersCollectionName)
    .doc(offerModel.offerId)
    .get()
    .then(
            (value)async{
              await value.reference.update(offerModel.jsonForUpdateStatus());
            }
    );

  }


}