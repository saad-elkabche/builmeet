
import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/refresh_widget.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/employee_dialogue.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/floating_action_location.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/offer_widget_client.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/offers_body.dart';
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

  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _listeneOnMainSecreen();
  }

  @override
  Widget build(BuildContext context) {

    width=MediaQuery.sizeOf(context).width;
    height=MediaQuery.sizeOf(context).height;

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
            body:Column(
              children: [
                Expanded(
                    child: RefreshWidget(
                        refresh:()async{
                          _fetchData();
                          await Future.delayed(const Duration(seconds: 2));
                          },
                        child: _body(state))
                ),
                BlocListener<HomeBloc,HomeState>(
                    listener: _listener,
                    child:const SizedBox()
                )
              ],
            ),
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
          MyCustomButton(name: getLang(context, "try_again"),textColor: Colors.white,color: AppColors.primaryColor,onClick: _fetchData,)
        ],
      );
    }else if(state.fetchingDataStatus==AppStatus.success){
      return OffersBody(
        appMode: state.appMode!,
        isLoading: false,
        onPasInterss: onEmployeeNotInressted,
        onInterss: onEmployeeInteress,
        onLesIntersses: onClientLesInteresse,
        onStop: onClientStop,
        offers:state.offers ,);
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




  void onClientStop(OfferEntity offer) {
   BlocProvider.of<HomeBloc>(context).add(ClientStopOffer(offer));
  }

  void onClientLesInteresse(OfferEntity offer) {
    if((offer.countInterests ?? 0)>0){
      GoRouter.of(context).push(Routes.offerInterests, extra: offer);
    }
  }

  void onEmployeeInteress(OfferEntity offer) async{
    var result=await showDialog(
        context: context,
        builder: (context){
          return EmployeeDialogue();
        }
    );

    if((result is bool) && result ){
      BlocProvider.of<HomeBloc>(context).add(EmployeeInteresser(offerEntity: offer));
    }else if(result is double){
      BlocProvider.of<HomeBloc>(context).add(EmployeeInteresser(offerEntity: offer,price: result));
    }
  }

  void onEmployeeNotInressted(OfferEntity offer,int index) {
    BlocProvider.of<HomeBloc>(context).add(EmployeeNotIntersted(offerEntity: offer, index: index));
  }








  void _listener(BuildContext context, HomeState state) {
    if(state.operationStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.operationStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, () {hideDialogue(context); });
    }else if(state.operationStatus==AppStatus.success){
      hideDialogue(context);
      showInfoDialogue(MessageUi(getLang(context, "success"), AppStatus.success, 'Okay'), context, () {hideDialogue(context); });
    }
  }
}


