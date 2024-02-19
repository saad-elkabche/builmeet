import 'dart:io';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:flutter/material.dart';





class ProfilePic extends StatelessWidget {
  File? image;
  VoidCallback? onPickImage;

  ProfilePic({this.image,this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
          image: image!=null
            ?
          DecorationImage(
            image: FileImage(image!),
            fit: BoxFit.cover
          )
              :
              null
        ),
        child: image==null?Image.asset(AppImages.img_person):null,
      ),
    );
  }
}
