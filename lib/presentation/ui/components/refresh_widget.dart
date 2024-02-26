import 'package:builmeet/core/constants/app_colors.dart';
import 'package:flutter/material.dart';



class RefreshWidget extends StatelessWidget {
  Future<void> Function() refresh;
  Widget child;
   RefreshWidget({required this.refresh,required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryColor,
        onRefresh:refresh,
        child: child,
    );
  }
}
