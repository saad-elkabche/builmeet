import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/offer_interests/offer_interests_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/secreens/offer_interests_secreen/components/interest_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocBuilder<OfferInterestsBloc,OfferInterestsState>(
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
    );
  }

  void _fetchData() {
    BlocProvider.of<OfferInterestsBloc>(context).add(FetchInterests());
  }


  void onAccept(InterestEntity interstEntity) {
  }

  void onRefused(InterestEntity interstEntity) {
  }

  void onVoir(InterestEntity interstEntity) {
  }
}

