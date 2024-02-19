import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/presentation/ui/components/shimming_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';




class MyCircleImage extends StatelessWidget {
  double width;
  String url;

   MyCircleImage({required this.width,required this.url});

  @override
  Widget build(BuildContext context) {
    return   Container(
      width:width,
      height: width,
      clipBehavior: Clip.hardEdge,
      decoration:  BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.grey[400]!,offset: Offset(5, 5),blurRadius: 15,)
          ]
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (context,str,obj){
          return Container(color: Colors.redAccent,);
        },
        placeholder: (context,str){
          return ShimmingWidget(width: width, height: width,isRectangle: false,baseColor:Colors.grey[200]!,shimmingColor: AppColors.primaryColor,);
        },
      )
    );
  }
}

