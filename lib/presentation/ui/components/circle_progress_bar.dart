import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class MyCustomCircleBar extends StatelessWidget {
   MyCustomCircleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child:LoadingAnimationWidget.staggeredDotsWave(color:const Color(0xfffff89e), size: 30)
    );
  }
}


