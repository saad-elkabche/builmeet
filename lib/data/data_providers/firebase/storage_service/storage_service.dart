


import 'dart:io';

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
}

