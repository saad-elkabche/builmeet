import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
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
    //double height=MediaQuery.sizeOf(context).height;

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
                Text('${calculePrice().toStringAsFixed(2)} €',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 25,),

            if(offerEntity?.interestEntity==null)
            getAction(),

            if(offerEntity?.interestEntity!=null)
              getOfferStatus()

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
    switch(offerEntity!.interestEntity!.interestStatus){
      case InterestsStatus.accepted:return "Accepter";
      case InterestsStatus.pending:return "Pending";
      case InterestsStatus.refused:return  "Refused";
      default:return '';
    }
  }



  double calculePrice(){
    if(offerEntity!.pricingType==PricingTypes.total){
      return offerEntity!.price!;
    }else{
      double total=calculTotalMission(
          dateBegin: offerEntity!.dateDebut!,
          dateEnd: offerEntity!.dateFin!,
          nbHour: offerEntity!.nbHourPerDay!,
          hourPrice: offerEntity!.price!,
          userType: UserTypes.employee,
          commision: 10);
      return total;
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
    if(offerEntity!.orderStatus==OrderStatus.pending){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyCustomButton(name: 'Pas interesse',
            height: 40,
            width: 140,
            color: Colors.white,
            borderRadius: 20,
            horizontalMargin: 0,
            hasBorder: true,
            textColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,
            onClick:()=> onPasInterss?.call(offerEntity!,index),
          ),
          MyCustomButton(name: 'Interesse',
            height: 40,
            width: 140,
            color: AppColors.primaryColor,
            borderRadius: 20,
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

    String rate=(offerEntity?.creator?.rate ?? 0.0).toString();

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
            Text(rate,style: GoogleFonts.inter(color: Colors.amber,fontWeight: FontWeight.bold),)
          ],
        )
      ],
    );
  }

  Widget getOfferStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Status:',style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
        Text(getStatus(),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),)
      ],
    );
  }



}


