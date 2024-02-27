


import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/presentation/ui/secreens/edit_employee_infos_secreen/edit_employee_infos_secreen.dart';
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
  static const String becomeEmployee='/employee';
  static const String editEmployeeInfos='/employeeEdit';
  static const String offerInterests='/offerInterests';
  static const String voirInterest='/voirInterest';

  GlobalKey<NavigatorState> parentKey=GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> childKey=GlobalKey<NavigatorState>();

  static GoRouter router=GoRouter(
    initialLocation:onboarding,

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
                    pageBuilder:(context,state)=> NoTransitionPage(child: JournalScreen.page())
                  )
                ]
            ),


            StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: home,
                      pageBuilder:(context,state)=> NoTransitionPage(child: HomeScreen.page())
                  )
                ]
            ),




            StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: profile,
                      pageBuilder:(context,state)=> NoTransitionPage(child: ProfileScreen.page())
                  )
                ]
            )
          ],

        ),
        GoRoute(
            path: addOffer,
            pageBuilder: (context,state){
              return NoTransitionPage(
                  child: AddOfferScreen.page()
              );
            }
        ),

        GoRoute(
          path: becomeEmployee,
          redirect: (context,state){
            if(state.extra is! UserEntity){
              return profile;
            }
          },
          pageBuilder: (context,state){
            UserEntity userEntity=state.extra as UserEntity;
            return NoTransitionPage(child: BecomeEmployeeSecreen.page(userEntity));
          }
        ),
        GoRoute(
            path: editEmployeeInfos,
            redirect: (context,state){
              if(state.extra is! UserEntity){
                return profile;
              }
            },
            pageBuilder: (context,state){
              UserEntity user=state.extra as UserEntity;
              return NoTransitionPage(child: EditEmployeeInfosSecreen.page(userEntity: user));
            }
        ),

        GoRoute(
            path: offerInterests,
            redirect: (context,state){
              if(state.extra is! OfferEntity){
                return home;
              }
            },
            pageBuilder: (context,state){
              OfferEntity offerEntity=state.extra as OfferEntity;
              return NoTransitionPage(
                  child:OfferInterestsScreen.page(offerEntity: offerEntity)
              );
          }
        ),
        GoRoute(
            path: voirInterest,
            redirect: (context,state){
              if(state.extra is! InterestEntity){
                return home;
              }
            },
            pageBuilder: (context,state){
              InterestEntity interest=state.extra as InterestEntity;
              return NoTransitionPage(
                  child:VoirEmployeeScreen.page(interestEntity: interest)
              );
            }
        )


      ]
  );

}