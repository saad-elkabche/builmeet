


import 'package:builmeet/data/data_providers/firebase/models/offer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DBService{

  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  FirebaseStorage firebaseStorage;

  final String offersCollectionName='offers';


  DBService({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage});


  Future<void> createOffer(OfferModel offerModel)async{
    await firebaseFirestore.collection(offersCollectionName)
        .add(offerModel.toJson());
  }


}