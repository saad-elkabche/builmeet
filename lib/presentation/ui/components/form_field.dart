
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';







class MyFormField extends StatefulWidget {


  Color hintColor;
  Color labelColor;
  Color activeBorderColor;
  Color borderColor;
  Color? fillColor;

  double fontSizeLabel;
  double fontSizeHint;
  double fontSizetext;
  double borderRadius;
  double borderWidth;

  FontWeight fontWeightLabel;
  FontWeight fontWeightHint;
  FontWeight fontWeightText;


  int? maxLenght;

  String label;
  String hint;

  Widget? leading;
  Widget? suffix;


  Widget? openEyeIcon;
  Widget? closeEyeIcon;

  bool isPassWord;
  bool readOnly;
  bool isLarge;


  TextInputType inputType;

  List<TextInputFormatter>? formatters;




  TextEditingController? controller;
  void Function(String)? onChange;
  String? Function(String?)? validator;
  void Function()? onSuffixClick;



  MyFormField({
    required this.hint,
    required this.label,
    this.leading,
    this.suffix,
    this.borderColor=const Color(0xff0B3167),
    this.activeBorderColor=const Color(0xffFE6D00),
    this.hintColor=const Color(0xff0B3167),
    this.labelColor=const Color(0xff0B3167),
    this.fontWeightLabel=FontWeight.bold,
    this.fontWeightHint=FontWeight.normal,
    this.fontSizeHint=12,
    this.fontSizeLabel=15,
    this.fontSizetext=14,
    this.fontWeightText=FontWeight.w500,
    this.borderRadius=10,
    this.borderWidth=1.5,
    this.isPassWord=false,
    this.controller,
    this.fillColor,
    this.onChange,
    this.maxLenght,
    this.validator,
    this.onSuffixClick,
    this.readOnly=false,
    this.openEyeIcon,
    this.closeEyeIcon,
    this.isLarge=false,
    this.inputType=TextInputType.text,
    this.formatters
}) ;

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {

   late bool hidePass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hidePass=widget.isPassWord;
  }


  @override
  Widget build(BuildContext context) {

    return widget.label.isNotEmpty
        ?
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(widget.label,style: GoogleFonts.poppins(color: widget.labelColor,fontSize: widget.fontSizeLabel,fontWeight: widget.fontWeightLabel),),
        SizedBox(height: 10,),
        field()

      ],
    )
        :field();
  }
  Widget field()=>TextFormField(

    inputFormatters:widget.formatters ,
    keyboardType: widget.inputType,
    readOnly: widget.readOnly,
    maxLength: widget.maxLenght,
    onChanged: onTextChange,
    maxLines: widget.isLarge?4:1,
    validator: widget.validator,
    style: GoogleFonts.poppins(fontWeight: widget.fontWeightText,fontSize: widget.fontSizetext),
    obscureText: hidePass,
    controller: widget.controller,
    decoration: InputDecoration(
      fillColor: widget.fillColor,
      filled: widget.fillColor!=null,
      contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
      hintText: widget.hint,
      hintStyle:GoogleFonts.poppins(color: widget.hintColor,fontSize: widget.fontSizeHint,fontWeight: widget.fontWeightHint),
      prefixIcon: widget.leading,
      suffixIcon:GestureDetector(
          onTap: onSuffixTap,
          child: getSuffixIcon() ?? const SizedBox() ,
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor,width: widget.borderWidth)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.activeBorderColor,width: widget.borderWidth)
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.activeBorderColor,width: widget.borderWidth)
      ),
      focusedErrorBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: widget.activeBorderColor,width: widget.borderWidth)
      ),
      disabledBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: widget.activeBorderColor,width: widget.borderWidth)
  ),


    ),
  );

  void onSuffixTap() {
    if(widget.isPassWord){
      setState(() {
        hidePass=!hidePass;
        print(hidePass);
      });
    }
    widget.onSuffixClick?.call();
  }
  Widget? getSuffixIcon(){
    if(widget.isPassWord){
      if((widget.controller?.text ?? '').trim().isEmpty){
        return SizedBox();
      }else{
        return hidePass?widget.openEyeIcon:widget.closeEyeIcon;
      }
    }else{
      return widget.suffix;
    }
  }


  void onTextChange(String value) {
    setState(() {

    });
    widget.onChange?.call(value);
  }
}
