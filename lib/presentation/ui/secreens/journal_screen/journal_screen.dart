import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/journal_bloc/journal_bloc.dart' ;
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart' as MSB;
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/refresh_widget.dart';
import 'package:builmeet/presentation/ui/secreens/journal_screen/components/journal_offer_client.dart';
import 'package:builmeet/presentation/ui/secreens/journal_screen/components/journal_offer_employee.dart';
import 'package:builmeet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


class JournalScreen extends StatefulWidget {

  JournalScreen({Key? key}) : super(key: key);

  static Widget page() {
    Repository repository = Dependencies.get<Repository>();
    SharedPrefService sharedPrefService = Dependencies.get<SharedPrefService>();

    return BlocProvider<JournalBloc>(
      create: (context) => JournalBloc(
          repository: repository,
          sharedPrefService: sharedPrefService),
      child: JournalScreen(),
    );
  }


  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {

  int currentTab = 0;


  @override
  void initState() {
    super.initState();
    _fetchData();

    MSB.MainScreenBloc mainSecreenBloc=BlocProvider.of<MSB.MainScreenBloc>(context);
    BlocProvider.of<JournalBloc>(context).add(ListeneToMainSecreenBloc(mainSecreenBloc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        centerTitle: true,
        title: Text(
          'Grérer les commandes',
          style: GoogleFonts.inter(color: AppColors.primaryColor,
              fontSize: 23,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          return RefreshWidget(
            refresh: ()async{
              _fetchData();
              await Future.delayed(const Duration(seconds: 2));
            },
            child: Column(
              children: [
                BlocListener<JournalBloc,JournalState>(
                    listener: _listener,
                  child: const SizedBox(),
                ),
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: AppColors.scaffoldColor,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      item('Actif', 0),
                      item('Terminé', 1),
                      if(state.appMode!=UserTypes.client)
                      item('Autre',2),
                    ],
                  ),
                ),
                Expanded(
                    child: mainBody(state)
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget mainBody(JournalState state) {
    if (state.fetchingDataStatus == AppStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor,),
      );
    } else if (state.fetchingDataStatus == AppStatus.error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('error', style: GoogleFonts.inter(color: Colors.red),),
          const SizedBox(height: 10,),
          MyCustomButton(
            name: 'Try again',
            height: 45,
            borderRadius: 23,
            onClick: _fetchData,
            color: AppColors.primaryColor,
            textColor: Colors.white,)
        ],
      );
    } else if (state.fetchingDataStatus == AppStatus.success) {
      return _body(state);
    }
    return SizedBox();
  }


  void selectTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  Widget item(String name, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectTab(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.inter(color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold),),
            if(index == currentTab)
              Container(
                width: double.infinity,
                height: 2,
                color: AppColors.primaryColor,
              )
          ],
        ),
      ),
    );
  }


  void _fetchData() {
    BlocProvider.of<JournalBloc>(context).add(FetchData());
  }

  Widget _body(JournalState state) {
    if (state.appMode == UserTypes.client) {
      if (currentTab == 0) {
        List<OfferEntity> offers=state.getActifOffersForClient();
        return ListView(
          children:[
            ... List.generate(offers.length, (index) =>
                JournalOfferClient(offerEntity: offers.elementAt(index),onVoir: _onVoirOffer,onTermine: _onTermine,)
            ),
            const SizedBox(height: 75,)
          ]
        );
      } else{
        List<OfferEntity> offers=state.getFinishedOffersForClient();
        return ListView(
          children: [
            ... List.generate(offers.length, (index) =>
                JournalOfferClient(offerEntity: offers.elementAt(index),onVoir: _onVoirOffer,)
            ),
            const SizedBox(height: 75,)
          ],
        );
      }
    } else {
      if (currentTab == 0) {
        List<InterestEntity> interests=state.getInterestsActifOfferFormEmployee();
        return ListView(
          children: [
            ...List.generate(interests.length,
                    (index) => JournalOfferEmployee(
                      interestEntity: interests.elementAt(index),
                      onRate: _employeeRateOffer,
                      onVoir:_onVoirOfferForEmployee,)
            ),
            const SizedBox(height: 70,)
          ],
        );
      } else if (currentTab == 1) {
        List<InterestEntity> interests=state.getInterestsFinishedForEmployee();
        return ListView(
          children: [
            ...List.generate(interests.length,
                    (index) => JournalOfferEmployee(
                      interestEntity: interests.elementAt(index),
                      onRate: _employeeRateOffer,
                      onVoir: _onVoirOfferForEmployee,)
            ),
            const SizedBox(height: 70,)
          ],
        );
      } else {
        List<InterestEntity> interests=state.getOtherOffersForEmployee();
        return ListView(
          children: [
            ...List.generate(interests.length,
                    (index) => JournalOfferEmployee(
                  interestEntity: interests.elementAt(index),
                  onVoir: _onVoirOfferForEmployee,)
            ),
            const SizedBox(height: 70,)
          ],
        );
      }
    }
    return const SizedBox();
  }




  void _listener(BuildContext context, JournalState state) async{
    if(state.operationStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.operationStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, (){hideDialogue(context);});
    }else if(state.operationStatus==AppStatus.success){
      hideDialogue(context);
      if(state.currentOperation==Operations.finishOffer){
        await GoRouter.of(context).push(Routes.ratingScreen,extra: state.operationOnOffer);
        _fetchData();
      }

    }
  }

  void _onVoirOffer(OfferEntity offer) async{
    await GoRouter.of(context).push(Routes.voirOffer,extra: offer);
    _fetchData();
  }

  void _onTermine(OfferEntity offer) {
    BlocProvider.of<JournalBloc>(context).add(ClientFinishOffer(offer));
    //print('termine');
  }

  void _onVoirOfferForEmployee(InterestEntity interestEntity) {
    GoRouter.of(context).push(Routes.voirOfferForEmployee,extra: interestEntity);
  }

  void _employeeRateOffer(InterestEntity interestEntity) async{
    await GoRouter.of(context).push(Routes.ratingScreen,extra: interestEntity.offer);
    _fetchData();
  }
}


