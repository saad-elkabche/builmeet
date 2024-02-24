import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/presentation/ui/components/shimming_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





class InfoItem extends StatelessWidget {
  String? info;
  dynamic subInfo;
  bool? isLoading;
  void Function()? onEdit;
  dynamic icon;
  bool withIcon;

   InfoItem({this.isLoading,this.withIcon=true,this.subInfo,this.icon,this.info,this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading:icon is String
        ?
      ImageIcon(AssetImage(icon),color: AppColors.primaryColor,)
        :
      Icon(icon,color: AppColors.primaryColor,)
      ,
      title:
      (isLoading ?? false)
          ?
          ShimmingWidget(width: 140, height: 10,baseColor: Colors.grey[200],shimmingColor: AppColors.primaryColor,)
          :
          Text(info!,style:GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15) ,),


      subtitle:(!(isLoading ?? false) && subInfo!=null)
          ?
      subInfo is String
          ?
      Text(subInfo!,style:GoogleFonts.inter(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 17) ,)
          :subInfo
          :
      null ,
      trailing:withIcon
          ?
      IconButton(
        onPressed: ()=>onEdit?.call(),
        icon: const Icon(Icons.edit,color: AppColors.primaryColor,),
      )
          :
      null,
    );
  }
}
