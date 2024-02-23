import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/shimming_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





class ProfileHeader extends StatelessWidget {

  String? url;
  void Function()? pickImage;
  String? name;
  bool? isLoading;


  ProfileHeader({
    this.name,
    this.pickImage,
    this.url,
    this.isLoading});

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height:height*0.2,
      decoration: const BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.grey,offset: Offset(0,4),blurRadius: 15)]
      ),
      child:Center(
        child: Column(
          mainAxisSize:MainAxisSize.min,
          children: [
            (isLoading ?? false)
                ?
            ShimmingWidget(width: 80,
              height: 80,
              isRectangle: false,
              shimmingColor: AppColors.primaryColor,baseColor: Colors.grey[200],)
               :
            image(),

            const SizedBox(height: 15,),


            (isLoading ?? false)
                ?
                ShimmingWidget(width: 110,
                  height: 10,
                  baseColor: Colors.grey[200],
                  shimmingColor: AppColors.primaryColor,)
                :
                Text(name!,
                  style: GoogleFonts.inter(color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),)


          ]
        ),
      ),
    );
  }

  Widget image(){
    return SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          clipBehavior: Clip.none,
           alignment: Alignment.center,
          children: [
            url!=null
                ?
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2,color: AppColors.primaryColor),
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(2,2),blurRadius: 10)]
                ),
                child: MyCircleImage(width: 80, url:url! ))
                :
            const CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey,
              //foregroundColor: Colors.grey,
              backgroundImage: AssetImage(AppImages.img_person),
            ),
            Positioned(
              right: -5,
              bottom: -5,
              child: GestureDetector(
                  onTap: ()=>pickImage?.call(),
                  child: Icon(Icons.camera_alt,size: 35,color:AppColors.primaryColor ))
            )
          ],
        )
    );
  }

}
