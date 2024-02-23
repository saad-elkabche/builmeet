import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/floating_action_location.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/offer_widget_client.dart';
import 'package:builmeet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {

  static Widget page(){
    Repository repository=Dependencies.get<Repository>();
    return BlocProvider<HomeBloc>(
        create: (context)=>HomeBloc(repository: repository),
        child: HomeScreen(),
    );
  }

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late UserTypes appMode;

  @override
  void initState() {
    super.initState();
    initializeAppMode();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    initializeAppMode();
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldColor,
          centerTitle: true,
          title: Text(
            AppStrings.appName,
            style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<HomeBloc,HomeState>(
          builder: (context,homeState){
            if(homeState.fetchingDataStatus==AppStatus.loading){
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor,),
              );
            }else if(homeState.fetchingDataStatus==AppStatus.error){
              return Column(
                children: [
                  Text('Error',style: GoogleFonts.inter(color: Colors.red),),
                  MyCustomButton(name: 'Try Again',textColor: Colors.white,color: AppColors.primaryColor,onClick: _fetchData,)
                ],
              );
            }else if(homeState.fetchingDataStatus==AppStatus.success){
              return ListView(
                children: [
                  ...List.generate(homeState.offers?.length ?? 0, (index) => OfferWidgetClient(
                    offerEntity: homeState.offers!.elementAt(index),
                  )),
                  const SizedBox(height: 70,)
                ]
              );
            }
            return SizedBox();
          },
        ),
        floatingActionButtonLocation: MyFloatingActionLocation(
            bottomNavHeight: 63, margin: 15),
        floatingActionButton:appMode==UserTypes.client
            ?
        FloatingActionButton(
          onPressed: _addOffer,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.add,size: 40,color: AppColors.scaffoldColor,),
        )
            :
        null
    );
  }



  void _addOffer() async{
    UserEntity me = BlocProvider
        .of<MainScreenBloc>(context)
        .state
        .me!;
    await GoRouter.of(context).push(Routes.addOffer, extra: me);
    _fetchData();
  }

  void _fetchData()  {
    BlocProvider.of<HomeBloc>(context).add(FetchOffers(appMode));
  }
  void initializeAppMode(){
    appMode=BlocProvider.of<MainScreenBloc>(context).state.appMode!;
  }
}


