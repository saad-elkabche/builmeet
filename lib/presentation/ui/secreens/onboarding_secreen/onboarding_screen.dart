

import 'dart:async';

import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/presentation/blocs/onboarding_cubit/onboarding_cubit.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';




class OnboardingScreen extends StatefulWidget {
  
  static Widget page(){
    return BlocProvider<OnboardingCubit>(
      create: (context)=>OnboardingCubit(),
      child: OnboardingScreen(),
    );
  }
  static FutureOr<String?> redirect(context,state){
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
    if(!sharedPrefService.getValue(SharedPrefService.firstUse, true)){
      return Routes.login;
    }
  }
  
  
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Column(
        children: [
         
          Expanded(
            flex: 3,
              child: Center(child: Image.asset(AppImages.img_onboarding,fit: BoxFit.cover,width: width*0.9,))),
          Expanded(
            flex: 2,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.appName,
                  style: GoogleFonts.inter(color: AppColors.primaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(AppStrings.onBoardingStrings,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),),
                ),
                const SizedBox(height: 15,),
                MyCustomButton(name: AppStrings.onboardingAction,
                  fontSize: 25,
                  color: AppColors.primaryColor,borderRadius: 25,height: 50,onClick: onCommencerClick,),
                BlocListener<OnboardingCubit,OnboardingState>(
                    listener: (context,state){
                      if(state.settingFirstUseStatus==AppStatus.success){
                        GoRouter.of(context).pushReplacement(Routes.login);
                      }
                    },
                  child: SizedBox(),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  void onCommencerClick() {
    BlocProvider.of<OnboardingCubit>(context).setFirstUseValue();
  }



}


