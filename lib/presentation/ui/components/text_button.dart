import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





class MyTextButton extends StatelessWidget {
  String name;
  IconData? icon;
  Color color;
  void Function()? onclick;

  MyTextButton({required this.name,this.icon,this.onclick,required this.color});

  @override
  Widget build(BuildContext context) {
    return icon!=null
        ?TextButton.icon(onPressed:()=>onclick?.call(), icon:Icon(icon,color: color,) , label:_getText(name))
        :TextButton(onPressed: ()=>onclick?.call(), child: _getText(name));
  }

  Widget _getText(String name)=>Text(name,style: GoogleFonts.aBeeZee(color: color),);
}
