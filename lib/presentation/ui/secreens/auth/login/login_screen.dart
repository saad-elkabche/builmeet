

import 'dart:async';

import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/auth/login_bloc/login_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:builmeet/presentation/ui/components/text_button.dart';
import 'package:builmeet/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';





class LoginSecren extends StatefulWidget {

  static Widget page(){

    Repository repository=Dependencies.get<Repository>();
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();

    return BlocProvider<LoginBloc>(
        create: (context)=>LoginBloc(repository: repository,sharedPrefService: sharedPrefService),
        child:LoginSecren() ,
    );
  }

  static FutureOr<String?> redirect(context,state){
    FirebaseAuth firebaseAuth=Dependencies.get<FirebaseAuth>();
    if(firebaseAuth.currentUser!=null){
      return Routes.home;
    }
  }

  LoginSecren({Key? key}) : super(key: key);

  @override
  State<LoginSecren> createState() => _LoginSecrenState();
}

class _LoginSecrenState extends State<LoginSecren> {
  late GlobalKey<FormState> formState;
  
  late TextEditingController addressEmail;
  late TextEditingController password;


  @override
  void initState() {
    super.initState();
    addressEmail=TextEditingController();
    password=TextEditingController();
    formState=GlobalKey<FormState>();
  }


  @override
  void dispose() {
    addressEmail.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Form(
          key: formState,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(AppStrings.appName,
                      style: GoogleFonts.inter(color: AppColors.primaryColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20,),
                    MyFormField(
                        borderRadius: 10,
                        borderColor: AppColors.primaryColor.withOpacity(0.5),
                        activeBorderColor: AppColors.primaryColor,
                        fillColor: Colors.white,
                        hint: 'Adresse email',
                        controller: addressEmail,
                        validator: Validator()
                            .required()
                            .email()
                            .make(),
                        hintColor: Colors.grey,
                        label: ''),
                    const SizedBox(height: 20,),
                    MyFormField(
                        borderRadius: 10,
                        borderColor: AppColors.primaryColor.withOpacity(0.5),
                        activeBorderColor: AppColors.primaryColor,
                        fillColor: Colors.white,
                        hint: 'Mot de passe',
                        hintColor: Colors.grey,
                        controller: password,
                        isPassWord: true,
                        validator: Validator()
                            .required()
                            .make(),
                        suffix: const Icon(Icons.remove_red_eye_rounded,color: AppColors.primaryColor,),
                        openEyeIcon: const Icon(Icons.remove_red_eye_rounded,color: AppColors.primaryColor,),
                        closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: AppColors.primaryColor,),
                        label: ''),
                    const SizedBox(height: 20,),

                    MyCustomButton(name: "Se connecter",
                      color: AppColors.primaryColor,
                      borderRadius: 25,
                      height: 50,
                      onClick: login,
                      fontSize: 25,),
                    const SizedBox(height: 20,),
                    MyTextButton(name: 'Mot passe oublié?',color: AppColors.primaryColor,onclick: forgetPassword,)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: MyCustomButton(name: 'Créer un compte',
                  color: AppColors.scaffoldColor,
                  hasBorder: true,
                  onClick: register,
                  borderRadius: 25,
                  height: 50,
                  fontSize: 25,
                  textColor: AppColors.primaryColor,),
              ),
              BlocListener<LoginBloc,LoginState>(
                  listener: _listener,
                  child: SizedBox(),
              )

            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if(formState.currentState!.validate()){
      BlocProvider.of<LoginBloc>(context).add(UserLogin(addressEmail.text, password.text));
    }
  }

  void register() {
    GoRouter.of(context).push(Routes.register);
  }

  void forgetPassword() {

  }

  void _listener(BuildContext context, LoginState state) {
    if(state.loginStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.loginStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi(state.error ?? 'error', AppStatus.error, 'Okay'), context, () {hideDialogue(context); });
    }else if(state.loginStatus==AppStatus.success){
      GoRouter goRouter = GoRouter.of(context);

      while(goRouter.canPop()){
        goRouter.pop();
      }
      goRouter.pushReplacement(Routes.home);
    }
  }
}
