import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/thems/light/light_theme.dart';
import 'package:builmeet/data/data_providers/firebase/auth_service/auth_service.dart';
import 'package:builmeet/data/data_providers/firebase/db_service/db_service.dart';
import 'package:builmeet/data/data_providers/firebase/firebase_data.dart';
import 'package:builmeet/data/repository.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/firebase_options.dart';
import 'package:builmeet/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await prepareDependencies();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarColor: AppColors.scaffoldColor,
        systemNavigationBarColor: AppColors.scaffoldColor,
        systemNavigationBarIconBrightness: Brightness.dark
    )
  );
  runApp(const BuilmeetApp());
}

Future<void> prepareDependencies() async{
  SharedPrefService sharedPrefService=await SharedPrefService.initializeService();
  DateFormat format = DateFormat.yMMMEd();

  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage=FirebaseStorage.instance;

  FirebaseData firebaseData=FirebaseDataIml(
      AuthService(firebaseAuth:firebaseAuth,
          firebaseFirestore: firebaseFirestore,
          firebaseStorage: firebaseStorage ),
      DBService(
        firebaseAuth: firebaseAuth,
        firebaseStorage: firebaseStorage,
        firebaseFirestore: firebaseFirestore
      )
  );

  Repository repository=RepositoryIml(firebaseData: firebaseData);

  Dependencies.put(sharedPrefService);
  Dependencies.put(format);
  Dependencies.put(repository);
  Dependencies.put(firebaseAuth);
}

class BuilmeetApp extends StatelessWidget {
  const BuilmeetApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Builmeet',
      theme:lightTheme,
      routerConfig: Routes.router,
    );
  }
}
