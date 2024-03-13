


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  FirebaseStorage firebaseStorage;

  static const String profilesFolderName='profiles';
  static const String documentsFolderName='documents';

  StorageService({ required this.firebaseStorage});

  Future<String?> uploadFile(File file,String folder,String fileName)async{
    Reference ref = firebaseStorage.ref(folder).child(fileName);
    await ref.putFile(file);
    String url=await ref.getDownloadURL();
    return url;
  }

  Future<List<String>> uploadFiles(List<File> files,String folder)async{
    Reference reference=firebaseStorage.ref(folder);
    List<String> urls=[];
    String fileName=Timestamp.now().microsecondsSinceEpoch.toString();
    for(int i=0;i<files.length;i++){
      Reference newRef=reference.child("$fileName${i+1}.jpg");
      await newRef.putFile(files.elementAt(i));
      String url=await newRef.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> deleteImageByUrl(String url)async{
    Reference reference=firebaseStorage.refFromURL(url);
    await reference.delete();
  }


}

