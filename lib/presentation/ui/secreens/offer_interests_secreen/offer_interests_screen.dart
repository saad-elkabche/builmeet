

import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/offer_interests/offer_interests_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/secreens/offer_interests_secreen/components/interest_widget.dart';
import 'package:builmeet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';







class OfferInterestsScreen extends StatefulWidget {
  OfferInterestsScreen({Key? key}) : super(key: key);



  static Widget page({required OfferEntity offerEntity}){
    Repository repository=Dependencies.get<Repository>();
    return BlocProvider<OfferInterestsBloc>(
        create: (context)=>OfferInterestsBloc(offerEntity: offerEntity,repository: repository),
      child: OfferInterestsScreen(),
    );
  }



  @override
  State<OfferInterestsScreen> createState() => _OfferInterestsScreenState();
}

class _OfferInterestsScreenState extends State<OfferInterestsScreen> {



  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'les intéressés',
          style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          BlocListener<OfferInterestsBloc,OfferInterestsState>(
              listener: _listenner,
            child: SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<OfferInterestsBloc,OfferInterestsState>(
              builder: (context,state){
                if(state.fetchingInterestsStatus==AppStatus.loading){
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                }else if(state.fetchingInterestsStatus==AppStatus.error){
                  return Column(
                    mainAxisAlignment:MainAxisAlignment.center ,
                    children: [
                      Text('eroor',style: GoogleFonts.inter(color: Colors.red),),
                      const SizedBox(height: 10,),
                      MyCustomButton(name: 'Try again',color: AppColors.primaryColor,textColor: Colors.white,onClick: _fetchData,)
                    ],
                  );
                }else if(state.fetchingInterestsStatus==AppStatus.success){
                  return ListView(
                    children: List.generate(state.interests?.length ?? 0,
                            (index) => InterestWidget(
                                interesEntity: state.interests!.elementAt(index),
                              onAccept: onAccept,
                              onRefused: onRefused,
                              onVoir: onVoir,
                            )
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _fetchData() {
    BlocProvider.of<OfferInterestsBloc>(context).add(FetchInterests());
  }


  void onAccept(InterestEntity interstEntity) {
    BlocProvider.of<OfferInterestsBloc>(context).add(AcceptInterest(interstEntity));
  }

  void onRefused(InterestEntity interstEntity) {
    BlocProvider.of<OfferInterestsBloc>(context).add(RefuseInterest(interstEntity));
  }

  void onVoir(InterestEntity interstEntity) async{
    await GoRouter.of(context).push(Routes.voirInterest,extra: interstEntity);
    _fetchData();
  }

  void _listenner(BuildContext context, OfferInterestsState state) {
    if(state.operationStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.operationStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, () {hideDialogue(context); });
    }else if(state.operationStatus==AppStatus.success){
      hideDialogue(context);
    }
  }
}

