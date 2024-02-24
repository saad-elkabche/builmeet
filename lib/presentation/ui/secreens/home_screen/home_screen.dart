import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
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

  static Widget page() {
    Repository repository = Dependencies.get<Repository>();
    SharedPrefService sharedPrefService = Dependencies.get<SharedPrefService>();
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(repository: repository,sharedPrefService: sharedPrefService),
      child: HomeScreen(),
    );
  }

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    _fetchData();
    _listeneOnMainSecreen();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.scaffoldColor,
              centerTitle: true,
              title: Text(
                AppStrings.appName,
                style: GoogleFonts.inter(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            body:_body(state),
            floatingActionButtonLocation: MyFloatingActionLocation(
                bottomNavHeight: 63, margin: 15),
            floatingActionButton:_floatingActionButton(state)
        );
      },
    );
  }


  void _addOffer() async {

    var result=await GoRouter.of(context).push(Routes.addOffer);
    if((result is bool) && result){
      _fetchData();
    }
  }

  void _fetchData() {
    BlocProvider.of<HomeBloc>(context).add(FetchOffers());
  }

  Widget _body(HomeState state) {
    if(state.fetchingDataStatus==AppStatus.loading){
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor,),
      );
    }else if(state.fetchingDataStatus==AppStatus.error){
      return Column(
        children: [
          Text('Error',style: GoogleFonts.inter(color: Colors.red),),
          MyCustomButton(name: 'Try Again',textColor: Colors.white,color: AppColors.primaryColor,onClick: _fetchData,)
        ],
      );
    }else if(state.fetchingDataStatus==AppStatus.success){
      return ListView(
          children: [
            ...List.generate(state.offers?.length ?? 0, (index) => OfferWidgetClient(
              offerEntity: state.offers!.elementAt(index),
            )),
            const SizedBox(height: 70,)
          ]
      );
    }
    return const SizedBox();
  }

  FloatingActionButton? _floatingActionButton(HomeState state) {
    if(state.appMode==UserTypes.client){
      return FloatingActionButton(
        onPressed: _addOffer,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add, size: 40, color: AppColors.scaffoldColor,),
      );
    }
  }

  void _listeneOnMainSecreen() {
    MainScreenBloc mainScreenBloc=BlocProvider.of<MainScreenBloc>(context);
    BlocProvider.of<HomeBloc>(context).add(ListeneToMainScreen(mainScreenBloc));
  }

}


