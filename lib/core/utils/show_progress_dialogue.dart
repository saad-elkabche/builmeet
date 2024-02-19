import 'package:builmeet/presentation/ui/components/circle_progress_bar.dart';
import 'package:flutter/material.dart';


void showProgressBar(BuildContext context) {
  showDialog(context: context,
    barrierDismissible: false,
    builder: (context) => MyCustomCircleBar(),
  );
}