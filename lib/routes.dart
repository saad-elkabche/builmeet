


import 'package:builmeet/presentation/ui/secreens/secreens.dart';
import 'package:builmeet/test_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';




class Routes{

  static const String login='/login';
  static const String register='/register';
  static const String onboarding='/onBoarding';
  static const String home='/';
  static const String journal='/journal';
  static const String profile='/profile';
  static const String addOffer='/addOffer';

  GlobalKey<NavigatorState> parentKey=GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> childKey=GlobalKey<NavigatorState>();

  static GoRouter router=GoRouter(
    initialLocation: '/login',

      routes: [
        GoRoute(
            path: onboarding,
            redirect:OnboardingScreen.redirect,
            pageBuilder: (context,state)=>NoTransitionPage(child: OnboardingScreen.page())
        ),
        GoRoute(
            path: login,
            redirect: LoginSecren.redirect,
            pageBuilder: (context,state)=>NoTransitionPage(child: LoginSecren.page())
        ),
        GoRoute(
            path: register,
            pageBuilder: (context,state)=>NoTransitionPage(child: RegisterSecren.page())
        ),
        GoRoute(
            path: '/test',
            pageBuilder: (context,state)=>NoTransitionPage(child: TestScreen())
        ),

        StatefulShellRoute.indexedStack(

          pageBuilder: (context,state,statefulShellRoute){
            return NoTransitionPage(
                child: MainScreen.page(statefulShellRoute)
            );
          },
          branches: [


            StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: journal,
                    pageBuilder:(context,state)=> NoTransitionPage(child: JournalScreen())
                  )
                ]
            ),


            StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: home,
                      pageBuilder:(context,state)=> NoTransitionPage(child: HomeScreen())
                  )
                ]
            ),




            StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: profile,
                      pageBuilder:(context,state)=> NoTransitionPage(child: ProfileScreen())
                  )
                ]
            )
          ],

        ),
        GoRoute(
            path: addOffer,
            pageBuilder: (state,context){
              return NoTransitionPage(
                  child: AddOfferScreen.page()
              );
            }
        )


      ]
  );

}