
import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/presentation/ui/components/text_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





Future<bool> showDialogueQuestion(BuildContext context,String question,[String positive="Yes",String negative="No"])async{
  bool result=await showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: Icon(Icons.question_mark,color: AppColors.primaryColor,),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      content: Text(question,style: GoogleFonts.aBeeZee(fontSize: 18),textAlign: TextAlign.center,),
      actionsOverflowAlignment:OverflowBarAlignment.center ,
      actions: [
        MyTextButton(name: "No",icon:Icons.cancel_outlined,color: Colors.redAccent,onclick: ()=>Navigator.pop(context,false)),
        MyTextButton(name: "Yes",icon:Icons.check,color: Colors.green,onclick: ()=>Navigator.pop(context,true)),
      ],
    );
  });
  return result;
}

