import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/data/data_providers/firebase/models/user_model.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';





class VoirOfferEmployee extends StatelessWidget {
  InterestEntity interestEntity;

  VoirOfferEmployee({required this.interestEntity});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        centerTitle: true,
        title:Text('Détails de la commande',style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),) ,
        leading: IconButton(
          onPressed: ()=>GoRouter.of(context).pop(),
          icon:const Icon(Icons.arrow_back_ios_new,color: AppColors.primaryColor,),
        ),
      ),
      body:SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40,),
                Align(
                    alignment: Alignment.center,
                    child: profile()),
                info('Metier requis', interestEntity.offer!.metier!),
                info('Description', interestEntity.offer!.description!),
                info('Adress', interestEntity.offer!.address!),


                listTile(
                    const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                    'De ${dateFormatter(interestEntity.offer!.dateDebut!)} à ${dateFormatter(interestEntity.offer!.dateFin!)}'
                ),
                listTile(const Icon(Icons.timer_outlined,color: AppColors.primaryColor,),'${interestEntity.offer!.nbHourPerDay} Heures/jour'),


                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Remunération',style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                    Text('${interestEntity.offer!.price} €',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 25,),
              ],

            ),
          ),
        ),
      ),
    );
  }

  String dateFormatter(DateTime date){
    return DateFormat('dd/MM/yyyy').format(date);
  }


  Widget profile(){

    UserEntity creator=interestEntity.offer!.creator!;

    String? imgProfile=creator.profilePicUrl;
    ImageProvider<Object> image=(imgProfile!=null?NetworkImage(imgProfile):AssetImage(AppImages.img_person)) as ImageProvider<Object>;

    double rate=(creator.rate ?? 0.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        imgProfile!=null
            ?
        MyCircleImage(width: 90, url: imgProfile)
            :
        CircleAvatar(
          radius: 50,
          backgroundImage: image,
        ),

        Text(creator.nomComplet!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star,color: Colors.amber,),
            Text(rateCalculator(rate, (creator.nbRates ?? 0)),style: GoogleFonts.inter(color: Colors.amber,fontWeight: FontWeight.bold),)
          ],
        )
      ],
    );
  }
  Widget listTile(Widget icon,String title){
    return ListTile(
      leading: icon,
      title:Text(title,
        style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w400),),
    );
  }
  Widget info(String title ,String value){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          const SizedBox(height: 5,),
          Text(value,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }


}
