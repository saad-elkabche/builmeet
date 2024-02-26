import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





class EmployeeDialogue extends StatefulWidget {
  const EmployeeDialogue({Key? key}) : super(key: key);

  @override
  State<EmployeeDialogue> createState() => _EmployeeDialogueState();
}

class _EmployeeDialogueState extends State<EmployeeDialogue> {
  late double width;

  String type='samePrice';

  late TextEditingController priceControler;
  late GlobalKey<FormState> formState;

  @override
  void initState() {
    super.initState();
    priceControler=TextEditingController();
    formState=GlobalKey<FormState>();
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
          child: Form(
            key: formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Intéressé',style: GoogleFonts.inter(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),

                Row(
                  children: [
                    Radio(
                      activeColor: AppColors.primaryColor,
                        focusColor: AppColors.primaryColor,

                        value:'samePrice' ,
                        groupValue: type,
                        onChanged: (value){
                          setState(() {
                            type=value!;
                          });
                        }
                    ),
                    Text('la meme remuneration',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),)
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        activeColor: AppColors.primaryColor,
                        focusColor: AppColors.primaryColor,
                        value:'augmentedPrice' ,
                        groupValue: type,
                        onChanged: (value){
                          setState(() {
                            type=value!;
                          });
                        }
                    ),
                    Text('Augmenter la remuneration',
                      style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                type!='samePrice'
                    ?
                    SizedBox(
                      width: 170,
                      child: MyFormField(
                          hint: '',
                          label: '',
                        inputType: TextInputType.number,
                        fillColor: AppColors.scaffoldColor,
                        borderColor: AppColors.primaryColor.withOpacity(0.5),
                        activeBorderColor: AppColors.primaryColor,
                        borderRadius: 15,
                        validator: Validator().required().number().make(),
                        controller: priceControler,
                        suffix: SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              '€',
                              style: GoogleFonts.inter(fontWeight:FontWeight.bold,color: Colors.black ),
                            ),
                          ),
                        ),
                      ),
                    )
                    :
                    const SizedBox(),
                const SizedBox(height: 20,),
                MyCustomButton(name: 'Confirmer',
                  hasBorder: true,
                  borderRadius: 20,
                  height: 50,
                  color: Colors.white,
                  textColor: AppColors.primaryColor,
                  width: 200,
                  fontSize: 18,
                  borderColor: AppColors.primaryColor,
                  onClick: _confirmer,
                )

              ],
            ),
          ),
        ),
      ) ,
    );
  }

  void _confirmer() {
    if(type!="samePrice"){
      if(formState.currentState!.validate()){
        double number=double.parse(priceControler.text);
        Navigator.of(context).pop(number);
      }
    }else{
      Navigator.of(context).pop(true);
    }
  }
}
