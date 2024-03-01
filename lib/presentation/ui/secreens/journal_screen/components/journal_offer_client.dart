import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class JournalOfferClient extends StatelessWidget {

  OfferEntity offerEntity;
  void Function(OfferEntity)? onVoir;
  void Function(OfferEntity)? onTermine;

  JournalOfferClient({required this.offerEntity,this.onVoir,this.onTermine});

  late double width;

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        width: width*0.9,
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor,width: 1.5),
          boxShadow:const [BoxShadow(color: Colors.grey,offset: Offset(3,3),blurRadius: 10)]
        ),
        child:Column(
          children: [
            infos(),
            const SizedBox(height: 10,),
            getActions()
          ],
        ) ,
      ),
    );
  }
  Widget infos(){
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           offerEntity.employee?.profilePicUrl!=null
                ?
            MyCircleImage(
              width: 80,
              url: offerEntity.employee!.profilePicUrl!,
            )
                :
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage(AppImages.img_person),
            ),
            Row(
              children: [
                const Icon(Icons.star,color: Colors.amber,),
                Text(rateCalculator(offerEntity.employee!.rate!,offerEntity.employee!.nbRates!),style: GoogleFonts.inter(color: Colors.amber),),
                Text('(${offerEntity.employee?.nbRates ?? 0})',style: GoogleFonts.inter(color: Colors.grey),)
              ],
            )
          ],
        ),
        const SizedBox(width: 35,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(offerEntity.employee?.nomComplet ?? '',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold)),
            const SizedBox(height: 5,),
            Text('(${offerEntity.employee?.metiers?.elementAt(0) ?? ''})',
                style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500)),
            const SizedBox(height: 5,),
            Text('${(offerEntity.price! * 1.1) ?? ''}€',
                  style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget getActions() {
    if(offerEntity.orderStatus==OrderStatus.finished){
      return voirButton();
    }else if(offerEntity.orderStatus==OrderStatus.active){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          voirButton(),
          finishButton()
        ],
      );
    }
    return SizedBox();
  }

  Widget voirButton(){
    return MyCustomButton(
        name:'Voir',
      color: Colors.white,
      width: 150,
      horizontalMargin: 0,
      borderColor: AppColors.primaryColor,
      textColor: AppColors.primaryColor,
      hasBorder: true,
      borderRadius: 23,
      height: 45,
      fontSize: 16,
      onClick:()=> onVoir?.call(offerEntity),
    );
  }
  Widget finishButton(){
    return MyCustomButton(
      name:'Terminer',
      color: AppColors.primaryColor,
      width: 150,
      horizontalMargin: 0,
      textColor: Colors.white,
      borderRadius: 23,
      height: 45,
      fontSize: 16,
      onClick:()=> onTermine?.call(offerEntity),
    );
  }

}
