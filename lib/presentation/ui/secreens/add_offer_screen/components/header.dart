import 'package:builmeet/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





class AddOfferHeader extends StatelessWidget {
  String title;
  VoidCallback onBack;
   AddOfferHeader({required this.title,required this.onBack});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: width,
      height: 50,
      child: Stack(
        children: [
          Row(
            children: [
              const SizedBox(width: 8,),
              IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),)
            ],
          ),
        ],
      ),
    );
  }
}
