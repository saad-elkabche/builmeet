import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/langs_extenssion.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';







class ChangeLangDialogue extends StatefulWidget {
  Langs lang;

  ChangeLangDialogue({required this.lang});

  @override
  State<ChangeLangDialogue> createState() => _ChangeLangDialogueState();
}

class _ChangeLangDialogueState extends State<ChangeLangDialogue> {
  late double width;

  late Langs _lang;


  @override
  void initState() {
    super.initState();
    _lang=widget.lang;
  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.sizeOf(context).width;

    return Center(
      child:Container(
        clipBehavior: Clip.hardEdge,
        width: width*0.9,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(getLang(context,'change_lang'),style: GoogleFonts.inter(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),

              Row(
                children: [
                  Radio(
                    activeColor: AppColors.primaryColor,
                      focusColor: AppColors.primaryColor,

                      value:Langs.english,
                      groupValue: _lang,
                      onChanged: (value){
                        setState(() {
                          _lang=value!;
                        });
                      }
                  ),
                  Text(getLang(context,'english'),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),)
                ],
              ),
              Row(
                children: [
                  Radio(
                      activeColor: AppColors.primaryColor,
                      focusColor: AppColors.primaryColor,
                      value:Langs.frensh,
                      groupValue: _lang,
                      onChanged: (value){
                        setState(() {
                          _lang=value!;
                        });
                      }
                  ),
                  Text(getLang(context,'frensh'),
                    style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),
                  )
                ],
              ),


              MyCustomButton(name: getLang(context,'Save'),
                width: 130,
                height: 42,
                borderRadius: 21,
                color: AppColors.primaryColor,
                onClick: _onSave,
                textColor: Colors.white,)

            ],
          ),
        ),
      ) ,
    );
  }



  void _onSave() {
    Navigator.of(context).pop(_lang);
  }
}
