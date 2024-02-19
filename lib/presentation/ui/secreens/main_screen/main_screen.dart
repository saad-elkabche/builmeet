import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:builmeet/presentation/ui/secreens/main_screen/components/bottom_nav_bar.dart';
import 'package:builmeet/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';








class MainScreen extends StatefulWidget {

  StatefulNavigationShell child;
   MainScreen({required this.child});


   static Widget page(StatefulNavigationShell child){

     Repository repository=Dependencies.get<Repository>();
     FirebaseAuth firebaseAuth=Dependencies.get<FirebaseAuth>();
     SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();

     return BlocProvider<MainScreenBloc>(
         create: (context)=>MainScreenBloc(
           sharedPrefService: sharedPrefService,
           repository: repository,
           firebaseAuth: firebaseAuth
         ),
       child: MainScreen(child: child),
     );
   }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainScreenBloc>(context).add(FetchData());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(child: SafeArea(child: widget.child)),
              BlocListener<MainScreenBloc,MainScreenState>(
                listener: _listener,
                child: SizedBox(),
              )
            ],
          ),
          Positioned(
            bottom: 8,
            child: BottomNavBar(
                currentIndex: widget.child.currentIndex,
                icons: [AppImages.ic_nav_1,AppImages.ic_nav_2,AppImages.ic_nav_3],onTap: _NavTap),
          ),

        ],
      )
    );

  }



  void _NavTap(int index) {

    widget.child.goBranch(
        index,
      initialLocation: index==widget.child.currentIndex
    );
  }

  void _listener(BuildContext context, MainScreenState state) {
    if(!state.isAuth){
      GoRouter goRouter=GoRouter.of(context);
      while(goRouter.canPop()){
        goRouter.pop();
      }
      goRouter.pushReplacement(Routes.login);
    }
  }
}
