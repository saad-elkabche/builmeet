
import 'package:builmeet/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class MyCustomButton extends StatelessWidget {
  String name;
  IconData? icon;
  Widget? iconWidget;
  Color color,textColor,iconColor,borderColor;
  double width;
  void Function()? onClick;
  double borderRadius,elevation,height,fontSize;
  Alignment alignment;
  bool hasBorder;

  MyCustomButton({
     required this.name,
    this.width=double.infinity,
    this.icon,
    this.color=AppColors.primaryColor,
    this.onClick,
    this.textColor=Colors.white,
    this.borderRadius=8,
    this.elevation=1,
    this.height=45,
    this.iconColor=Colors.white,
    this.alignment=Alignment.center,
    this.iconWidget,
    this.fontSize=17,
    this.hasBorder=false,
    this.borderColor=AppColors.primaryColor
});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 15),
    child: Center(
      child: Align(
        alignment:alignment ,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height
          ),
          child: icon!=null || iconWidget!=null
              ?ElevatedButton.icon(onPressed:()=>onClick?.call() , icon:icon!=null? Icon(icon,color: iconColor,):iconWidget!, label:_getText() ,style: _getStyle(),)
              :ElevatedButton(onPressed: ()=>onClick?.call(),style: _getStyle(),child: _getText(),),
        ),
      )
    )
    );
  }



 ButtonStyle _getStyle()=>ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(width: hasBorder?1.5:0,color: borderColor)
    ),
    backgroundColor: color,
    elevation: elevation,
    shadowColor: Colors.grey,

  );
  Widget _getText()=>Text(name,style: GoogleFonts.acme(color: textColor,fontSize: fontSize),);
}


