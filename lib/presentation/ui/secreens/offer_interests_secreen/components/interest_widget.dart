import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class InterestWidget extends StatelessWidget {
  InterestEntity interesEntity;
  void Function(InterestEntity interstEntity)? onVoir;
  void Function(InterestEntity interstEntity)? onAccept;
  void Function(InterestEntity interstEntity)? onRefused;

  InterestWidget({required this.interesEntity,this.onAccept,this.onRefused,this.onVoir});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    return Container(
      width: width*0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border:Border.all(color: AppColors.primaryColor,width: 1.5) ,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(4,4),blurRadius: 10)]
      ),
      child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          infos(),
          const SizedBox(height: 20),

          Row(
            children: [
              if(interesEntity.interestStatus==InterestsStatus.pending)
              Expanded(
                  child:MyCustomButton(name: 'Refused',
                    color: Colors.white,
                    height: 40,
                    borderRadius: 20,
                    horizontalMargin: 3,
                    textColor: AppColors.primaryColor,
                    onClick: ()=>onRefused?.call(interesEntity),
                    hasBorder: true,
                    fontSize: 15,
                    borderColor: AppColors.primaryColor,)
              ),
              Expanded(
                  child:Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 160
                      ),
                      child: MyCustomButton(name: 'Voir',
                        color: Colors.white,
                        textColor: AppColors.primaryColor,
                        hasBorder: true,
                        horizontalMargin: 3,
                        fontSize: 15,
                        height: 40,
                        borderRadius: 20,
                        onClick: ()=>onVoir?.call(interesEntity),
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  )
              ),
              if(interesEntity.interestStatus==InterestsStatus.pending)
              Expanded(
                  child:MyCustomButton(name: 'Accepter',
                    color: AppColors.primaryColor,
                    textColor: Colors.white,
                    onClick: ()=>onAccept?.call(interesEntity),
                    hasBorder: true,
                    height: 40,
                    fontSize: 15,
                    borderRadius: 20,
                    horizontalMargin: 3,
                    borderColor: AppColors.primaryColor,)
              ),
            ],
          )
        ],
      ) ,
    );
  }
  Widget infos(){
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            interesEntity.user?.profilePicUrl!=null
                ?
            MyCircleImage(
              width: 80,
              url: interesEntity.user!.profilePicUrl!,
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
                Text(rateCalculator(interesEntity.user?.rate ?? 0,interesEntity.user!.nbRates!),style: GoogleFonts.inter(color: Colors.amber),)
              ],
            )
          ],
        ),
        const SizedBox(width: 15,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(interesEntity.user!.nomComplet!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold)),
           Text('(${interesEntity.user!.metiers?.elementAt(0) ?? ''})',
                style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500)),
            if(interesEntity.interestPrice!=null)
            Text('${(interesEntity.interestPrice! * 1.1) ?? ''}€',
                style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
