import 'dart:io';

import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/presentation/ui/components/shimming_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';






class ImagesList extends StatelessWidget {
  double width;
  double height;
  List<String>? urls;
  List<File>? images;
  bool isEditable;
  void Function(int)? deleteRemoteImage;
  void Function(int)? deleteLocalImage;

  ImagesList({required this.height,
    required this.width,
    this.deleteLocalImage,
    this.deleteRemoteImage,
    this.isEditable=false,
    this.urls,this.images}){
    assert(images!=null || urls!=null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child:ListView(
        scrollDirection: Axis.horizontal,
        children:_getImages()
      )
    );
  }

  Widget imageWidget(dynamic image,int index){
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              clipBehavior: Clip.hardEdge,
              constraints: BoxConstraints(
                  maxWidth:width*0.7,
                  maxHeight:height*0.95
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.grey,blurRadius: 10,offset: Offset(4,4))]
              ),
              child:image is File
              ? Image.memory(image.readAsBytesSync(),fit: BoxFit.cover,)
              : CachedNetworkImage(
                imageUrl: image,
                placeholder: (context,str){
                  return ShimmingWidget(width: width*0.7, height: height*0.95,isRectangle: true,baseColor: Colors.grey[200],);
                },
                errorWidget: (context,str,obj){
                  return const Icon(Icons.image);
                },
              )
          ),
          if(isEditable)
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
                onTap: (){
                  if(image is File){
                    deleteLocalImage?.call(index);
                  }else{
                    deleteRemoteImage?.call(index);
                  }
                },
                child: const Icon(Icons.cancel,color: AppColors.primaryColor,size: 30,))
          )
        ],
      ),
    );
  }


  List<Widget> _getImages() {
    List<Widget> imgs=[];
    if(urls!=null){
      imgs.addAll(List.generate(urls!.length, (index) => imageWidget(urls!.elementAt(index), index)));
    }
    if(images!=null){
      imgs.addAll(List.generate(images!.length, (index) => imageWidget(images!.elementAt(index), index)));
    }
    return imgs;
  }

}
