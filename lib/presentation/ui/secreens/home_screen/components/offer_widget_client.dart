

import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/total_mission_calculator.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';




class OfferWidgetClient extends StatelessWidget {
  OfferEntity? offerEntity;
  bool? isloading;
  void Function(OfferEntity)? onStopClick;
  void Function(OfferEntity)? onInterestClick;

  OfferWidgetClient({this.isloading,this.offerEntity,this.onInterestClick,this.onStopClick}){
    assert(offerEntity!=null || (isloading ?? false));
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        margin: const EdgeInsets.symmetric(vertical: 10),
        width:width*0.9,
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(4,4),blurRadius: 10)],
          color: Colors.white,
          border: Border.all(color: AppColors.primaryColor,width: 1.5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            info('Metier requis', offerEntity!.metier!),
            info('Description', offerEntity!.description!),
            info('Adress', offerEntity!.address!),


            listTile(
              const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
              'De ${dateFormatter(offerEntity!.dateDebut!)} à ${dateFormatter(offerEntity!.dateFin!)}'
            ),
            listTile(const Icon(Icons.timer_outlined,color: AppColors.primaryColor,),'${offerEntity!.nbHourPerDay} Heures/jour'),


            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text('Remunération',style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                Text('${(offerEntity!.price! * 1.1).toStringAsFixed(2)} €',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 25,),

            getAction(),

          ],

        ),
      ),
    );
  }

  Widget listTile(Widget icon,String title){
    return ListTile(
      leading: icon,
      title:Text(title,
        style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w400),),
    );
  }

  String getStatus(){
    switch(offerEntity!.orderStatus){
      case OrderStatus.pending:return "En attend";
      case OrderStatus.active:return "actife";
      case OrderStatus.finished:return "complete";
      default:return '';
    }
  }






  String dateFormatter(DateTime date){
    return DateFormat('dd/MM/yyyy').format(date);
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

  Widget getAction() {
    print('==============from presentaion===========${offerEntity?.countInterests}');
    if(offerEntity!.orderStatus==OrderStatus.pending){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyCustomButton(name: 'Arreter',
            height: 40,
            width: 120,
            color: Colors.white,
            borderRadius: 20,
            hasBorder: true,
            horizontalMargin: 0,
            textColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,
            onClick:()=> onStopClick?.call(offerEntity!),
          ),
          MyCustomButton(name: 'Intéressés(${offerEntity?.countInterests ?? 0})',
            height: 40,
            width: 160,
            color: AppColors.primaryColor,
            borderRadius: 20,
            textColor: Colors.white,
            horizontalMargin: 0,
            onClick:()=> onInterestClick?.call(offerEntity!),
          ),

        ],
      );
    }else if(offerEntity!.orderStatus==OrderStatus.active){
      return SizedBox();
    }
    return SizedBox();
  }



}


