import 'package:builmeet/core/constants/app_colors.dart';
import 'package:flutter/material.dart';





class MyFloatingActionLocation extends StandardFabLocation{
  double bottomNavHeight;
  double margin;



  MyFloatingActionLocation({required this.bottomNavHeight,required this.margin});


  @override
  double getOffsetX(ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    double scaffoldWidth=scaffoldGeometry.scaffoldSize.width;
    double floatingActionWidth=scaffoldGeometry.floatingActionButtonSize.width;
    double x=scaffoldWidth-(floatingActionWidth+margin);
    return x;
  }

  @override
  double getOffsetY(ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    double scaffoldHeight=scaffoldGeometry.scaffoldSize.height;
    double floatingActionHeight=scaffoldGeometry.floatingActionButtonSize.height;
    double y=scaffoldHeight-(bottomNavHeight+floatingActionHeight+margin);
    return y;
  }

}