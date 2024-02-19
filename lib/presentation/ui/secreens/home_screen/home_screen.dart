import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/floating_action_location.dart';
import 'package:builmeet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';





class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late UserTypes appMode;

  @override
  Widget build(BuildContext context) {
    appMode=BlocProvider.of<MainScreenBloc>(context).state.appMode!;

    return Scaffold(

      body: const Center(
        child: Text("home"),
      ),
      floatingActionButtonLocation: MyFloatingActionLocation(bottomNavHeight: 63,margin: 15),
      floatingActionButton:appMode==UserTypes.client
          ?
      FloatingActionButton(
        onPressed: _addOffer,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add,size: 40,color: AppColors.scaffoldColor,),
      )
          :
      null ,

    );
  }

  void _onClick() {
    print('hello world');
  }

  void _addOffer() {
    GoRouter.of(context).push(Routes.addOffer);
  }
}


