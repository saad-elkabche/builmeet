import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/rating_cubit/rating_cubit.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';




class RatingScreeen extends StatefulWidget {
   RatingScreeen({Key? key}) : super(key: key);

   static Widget page({required OfferEntity offerEntity}){

     Repository repository=Dependencies.get<Repository>();
     SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();



     return BlocProvider<RatingCubit>(
         create: (context)=>RatingCubit(repository: repository,
             sharedPrefService: sharedPrefService,
             offerEntity: offerEntity),
       child: RatingScreeen(),
     );
   }

  @override
  State<RatingScreeen> createState() => _RatingScreeenState();
}

class _RatingScreeenState extends State<RatingScreeen> {

  int rate=1;


  @override
  void initState() {
    super.initState();
    BlocProvider.of<RatingCubit>(context).setAppMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener<RatingCubit,RatingState>(
                listener: _listener,
                child: SizedBox(),
            ),
            Image.asset(AppImages.img_check,fit: BoxFit.cover,),
            const SizedBox(height: 20,),
            Text(getLang(context, "mission_complete"),textAlign: TextAlign.center,style: GoogleFonts.inter(color: AppColors.primaryColor,fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),
            Text(getLang(context, "your_review"),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),

            const SizedBox(height: 15,),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                rate=rating.toInt();
                print(rate);
              },
            ),
            const SizedBox(height: 40,),
            MyCustomButton(
                name: 'Ok',
                width: 150,
              height: 45,
              borderRadius: 23,
              color: AppColors.scaffoldColor,
              hasBorder: true,
              borderColor: AppColors.primaryColor,
              textColor: AppColors.primaryColor,
              onClick:_submitRating,
            )
          ],
        ),
      ),
    );
  }

  void _submitRating() {

    BlocProvider.of<RatingCubit>(context).rateOffer(rate);
  }






  void _listener(BuildContext context, RatingState state) {
    if(state.ratingStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.ratingStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, () {hideDialogue(context); });
    }else if(state.ratingStatus==AppStatus.success){
      hideDialogue(context);
      GoRouter.of(context).pop();
    }
  }
}
