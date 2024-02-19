import 'package:builmeet/presentation/ui/secreens/main_screen/main_screen.dart';
import 'package:builmeet/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('create account'),
          onPressed: _createAcount,
        ),
      ),
    );
  }


  /*void navigate(){
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MainScreen()));
  }*/

  void _createAcount() async{
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
    try{
      UserCredential credential =await firebaseAuth.createUserWithEmailAndPassword(
          email: 'saadelkabche56@gmail.com',
          password: 'saad1234'
      );
      print('================Success=================${credential.user!.uid}');
      await firebaseFirestore.collection('users')
      .doc(credential.user!.uid)
      .set(
        {
          'name':'saad-el',
          'email':'saadelkabche56@gmail.com'
        }
      );
      print('data added sussefully');

    }on FirebaseAuthException catch(ex){
      print('=============code============${ex.code}');
      if(ex.code=='weak-password'){
        print('pass weak');
      }else if(ex.code=='email-already-in-use'){
        print('email in use');
      }
    }
  }
}
