import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';







class JournalOfferEmployee extends StatelessWidget {
  InterestEntity interestEntity;
  void Function(InterestEntity)? onVoir;
  void Function(InterestEntity)? onRate;


  JournalOfferEmployee({required this.interestEntity,this.onVoir,this.onRate}) ;


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
            status(),
            const SizedBox(height: 10,),
            SizedBox(
              width:double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  voirButton(),
                  if(interestEntity.interestStatus==InterestsStatus.accepted)
                  Positioned(
                      right: 5,
                      child: ratingBtn())
                ],
              ),
            )
          ],
        ) ,
      ),
    );
  }

  Widget infos(){

    UserEntity creator=interestEntity.offer!.creator!;

    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            interestEntity.offer?.creator?.profilePicUrl!=null
                ?
            MyCircleImage(
              width: 80,
              url: creator.profilePicUrl!,
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
                Text(rateCalculator(creator.rate!, creator.nbRates!),style: GoogleFonts.inter(color: Colors.amber),),
                Text('(${creator?.nbRates ?? 0})',style: GoogleFonts.inter(color: Colors.grey),)
              ],
            )
          ],
        ),
        const SizedBox(width: 35,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(creator.nomComplet ?? '',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold)),
            Text('${interestEntity.offer?.price ?? ''}€',
                style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
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
      onClick:()=> onVoir?.call(interestEntity),
    );
  }

  Widget ratingBtn() {
    if(interestEntity.offer!.orderStatus==OrderStatus.finished){

      if (interestEntity.offer!.employeeRate != null) {
        return Row(
          children: [
            const Icon(Icons.star, color: Colors.amber,),
            Text(interestEntity.offer!.employeeRate.toString(),
              style: GoogleFonts.inter(color: Colors.amber,fontWeight: FontWeight.bold),)
          ],
        );
      }else{
        return IconButton(onPressed:()=>onRate?.call(interestEntity), icon: const Icon(Icons.star_border,color: Colors.amber,));
      }
    }
    return const SizedBox();

  }

  String getStatusString(){
    if(interestEntity.interestStatus==InterestsStatus.refused){
      return 'refuse';
    }else if(interestEntity.interestStatus==InterestsStatus.taken){
      return 'already taken';
    }else if(interestEntity.interestStatus==InterestsStatus.pending){
      if(interestEntity.offer!.orderStatus==OrderStatus.stopped){
        return 'order Stoped';
      }else{
        return 'pending';
      }
    }
    return '';
  }

  Widget status() {
    if(interestEntity.interestStatus==InterestsStatus.accepted){
      return SizedBox();
    }
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Status',style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          Text(getStatusString(),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
