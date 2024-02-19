import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';





class BottomNavBar extends StatefulWidget {
  void Function(int)? onTap;
  List<String> icons;
  int currentIndex;

  BottomNavBar({this.onTap,this.currentIndex=0,required this.icons});




  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin{
  late double width;
  late double height;
  late int currentIndex;


   late List<AnimationController> controllers;


  @override
  void initState() {
    super.initState();
    currentIndex=widget.currentIndex;
    controllers=List.generate(widget.icons.length,
        (index) => AnimationController(vsync: this,
        duration: const Duration(milliseconds: 500),
        reverseDuration:const  Duration(milliseconds: 100)
        )
    );

    controllers.elementAt(currentIndex).value=1;

  }


  @override
  void dispose() {
    controllers.forEach((controller) {controller.dispose(); });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    width =MediaQuery.of(context).size.width;
    height =MediaQuery.of(context).size.height;
    return Container(
      foregroundDecoration: BoxDecoration(
        color: Colors.transparent
      ),
      width: width*0.95,
      height: 55,

      decoration: BoxDecoration(
        color:AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.grey,offset: Offset(2,2),blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
                widget.icons.length,
                (index){
                  return GestureDetector(
                    onTap:()=> _onItemTap(index),
                    child: ImageIcon(AssetImage(widget.icons.elementAt(index)),color: index==currentIndex
                        ?AppColors.primaryColor
                        :AppColors.primaryColor.withOpacity(0.6),
                      size: 35,
                    ).animate(
                        controller: controllers.elementAt(index),
                        autoPlay: false,
                        effects: [SlideEffect(curve: Curves.linearToEaseOut,begin: Offset(0,0),end: Offset(0,-0.25),duration: Duration(milliseconds: 500))]
                    ),
                  );
                }),
      ),
    );
  }

  _onItemTap(int index) {

    setState(() {
      currentIndex=index;
    });
    for(int i=0;i<controllers.length;i++){
      print('====================$i');
      if(i==index){
        controllers.elementAt(i).forward();
      }else{
        controllers.elementAt(i).reverse();
      }
    }
   widget.onTap?.call(index);
  }





}
