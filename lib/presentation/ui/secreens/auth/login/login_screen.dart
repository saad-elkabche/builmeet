import 'package:builmeet/presentation/blocs/auth/login_bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';





class LoginSecren extends StatefulWidget {

  static Widget page(){
    return BlocProvider<LoginBloc>(
        create: (context)=>LoginBloc(),
        child:LoginSecren() ,
    );
  }

  LoginSecren({Key? key}) : super(key: key);

  @override
  State<LoginSecren> createState() => _LoginSecrenState();
}

class _LoginSecrenState extends State<LoginSecren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('login'),
      ),
    );
  }
}
