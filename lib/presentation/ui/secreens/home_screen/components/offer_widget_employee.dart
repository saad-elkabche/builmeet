import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/core/services/total_mission_calculator.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';










class OfferWidgetEmployee extends StatelessWidget {
  OfferEntity? offerEntity;
  bool? isloading;
  int index;
  void Function(OfferEntity)? onInteress;
  void Function(OfferEntity,int)? onPasInterss;

  OfferWidgetEmployee({this.isloading,required this.index,this.offerEntity,this.onInteress,this.onPasInterss}){
    assert(offerEntity!=null || (isloading ?? false));
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;


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
            Align(
                alignment: Alignment.center,
                child: profile()),
            info(getLang(context, "metier_requis"), offerEntity!.metier!),
            info('Description', offerEntity!.description!),
            info(getLang(context, "adress"), offerEntity!.address!),


            listTile(
                const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                '${getLang(context, "de")} ${dateFormatter(offerEntity!.dateDebut!)} ${getLang(context, "a")} ${dateFormatter(offerEntity!.dateFin!)}'
            ),
            listTile(const Icon(Icons.timer_outlined,color: AppColors.primaryColor,),'${offerEntity!.nbHourPerDay} ${getLang(context, "hour_jour")}'),


            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text(getLang(context, "remuneration"),style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                Text('${offerEntity!.price!.toStringAsFixed(2)} €',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 25,),

            if(offerEntity?.interestEntity==null)
            getAction(context),

            if(offerEntity?.interestEntity!=null)
              getOfferStatus(context)

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

  String getStatus(BuildContext context){
    switch(offerEntity!.interestEntity!.interestStatus){
      case InterestsStatus.accepted:return getLang(context, "accepter");
      case InterestsStatus.pending:return getLang(context, "pending");
      case InterestsStatus.refused:return  getLang(context, "refuse");
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

  Widget getAction(BuildContext context) {
    if(offerEntity!.orderStatus==OrderStatus.pending){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyCustomButton(name: getLang(context,"not_interested"),
            height: 40,
            width: 140,
            color: Colors.white,
            borderRadius: 20,
            horizontalMargin: 0,
            hasBorder: true,
            fontSize: 15,
            textColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,
            onClick:()=> onPasInterss?.call(offerEntity!,index),
          ),
          MyCustomButton(name: getLang(context, "interes"),
            height: 40,
            width: 140,
            color: AppColors.primaryColor,
            borderRadius: 20,
            fontSize: 16,
            textColor: Colors.white,
            onClick:()=> onInteress?.call(offerEntity!),
          ),

        ],
      );
    }else if(offerEntity!.orderStatus==OrderStatus.active){
      return SizedBox();
    }
    return SizedBox();
  }

Widget profile(){
    String? imgProfile=offerEntity?.creator?.profilePicUrl;
    ImageProvider<Object> image=(imgProfile!=null?NetworkImage(imgProfile):AssetImage(AppImages.img_person)) as ImageProvider<Object>;

    double rate=(offerEntity?.creator?.rate ?? 0.0);
    int nbRate=offerEntity?.creator?.nbRates ?? 0;

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

        Text(offerEntity!.creator!.nomComplet!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star,color: Colors.amber,),
            Text(rateCalculator(rate, nbRate),style: GoogleFonts.inter(color: Colors.amber,fontWeight: FontWeight.bold),)
          ],
        )
      ],
    );
  }

  Widget getOfferStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(getLang(context, getLang(context, "status")),style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
        Text(getStatus(context),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),)
      ],
    );
  }



}


