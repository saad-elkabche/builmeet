import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/presentation/blocs/add_offer_bloc/add_offer_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:builmeet/presentation/ui/secreens/add_offer_screen/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';




class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<AddOfferBloc>(
        create: (context)=>AddOfferBloc(),
      child: AddOfferScreen(),
    );
  }


  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {

  late TextEditingController metierController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;
  late TextEditingController nbHourControler;
  late TextEditingController dateBeginController;
  late TextEditingController dateEndController;
  late TextEditingController priceController;

  late GlobalKey<FormState> formState;

  DateTime? dateDebut;
  DateTime? dateFin;


  bool isByHour=true;


  @override
  void initState() {
    super.initState();
    metierController=TextEditingController();
    descriptionController=TextEditingController();
    addressController=TextEditingController();
    nbHourControler=TextEditingController();
    dateBeginController=TextEditingController();
    dateEndController=TextEditingController();
    priceController=TextEditingController();
    formState=GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        leading:IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,)) ,
        title:  Text(AppStrings.addOfferTitle,style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Column(
              children: [
                const SizedBox(height: 15,),

                Text(AppStrings.addOfferDescription,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,),
                ),

                const SizedBox(height: 25,),

                MyFormField(
                    hint: 'Méties requis',
                    label: '',
                    hintColor: Colors.grey,
                    fillColor: Colors.white,
                    borderRadius: 10,
                    borderColor: AppColors.primaryColor.withOpacity(0.5),
                    activeBorderColor: AppColors.primaryColor,
                    validator:Validator()
                      .required()
                      .make(),
                    controller: metierController,
                ),

                const SizedBox(height: 15,),

                MyFormField(
                  hint: 'Description, chronologie, et autre ..',
                  label: '',
                  isLarge: true,
                  hintColor: Colors.grey,
                  fillColor: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor.withOpacity(0.5),
                  activeBorderColor: AppColors.primaryColor,
                  validator:Validator()
                      .required()
                      .make(),
                  controller: descriptionController,
                ),

                const SizedBox(height: 15,),

                MyFormField(
                  hint: 'Adresse',
                  label: '',
                  hintColor: Colors.grey,
                  fillColor: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor.withOpacity(0.5),
                  activeBorderColor: AppColors.primaryColor,
                  validator:Validator()
                      .required()
                      .make(),
                  controller: addressController,
                ),

                const SizedBox(height: 15,),

                input(name: "Nombre d'heure par jour",
                    colorText: AppColors.primaryColor,
                    fieldWidth: 90,
                    onChange: (val)=>calculFees(),
                    formatters: [
                      TextInputFormatter.withFunction(_hoursPerDaysFormatter)
                    ],
                    controller: nbHourControler,
                    hint: '',
                    suffix:  SizedBox(
                        width: 10,
                        height: 20,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('H  ',style: GoogleFonts.inter(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),))),
                    validator: Validator().required().make()
                ),

                const SizedBox(height: 15,),

                input(name: "Date de début",
                    colorText: AppColors.primaryColor,
                    fieldWidth: 150,
                    controller: dateBeginController,
                    hint: '',
                    isReadOnly: true,
                    onSuffixClick: _selectDateDebut,
                    suffix: const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                    validator: Validator().required().make()
                ),

                const SizedBox(height: 15,),

                input(name: "Date de fin",
                    colorText: AppColors.primaryColor,
                    fieldWidth: 150,
                    controller: dateEndController,
                    hint: '',
                    isReadOnly: true,
                    onSuffixClick: _selectDateFin,
                    suffix: const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                    validator: Validator().required().make()
                ),

                const SizedBox(height: 15,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rénumération',
                      style: GoogleFonts.inter(color: AppColors.primaryColor,fontSize: 16,fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Totale',
                          style: GoogleFonts.inter(
                              color: AppColors.primaryColor,
                              fontWeight:isByHour?FontWeight.normal:FontWeight.bold),),

                        Switch(
                            value: isByHour,
                            activeColor: AppColors.primaryColor,
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.white,
                            inactiveThumbColor: AppColors.primaryColor,
                            trackOutlineColor: MaterialStateColor.resolveWith((states) => Colors.white),
                            trackOutlineWidth: MaterialStateProperty.resolveWith((states) => 0),
                            onChanged: (value){
                              setState(() {
                                isByHour=value;
                              });
                              calculFees();
                            }
                        ),
                        Text('Heure',
                          style: GoogleFonts.inter(
                              color: AppColors.primaryColor,
                              fontWeight:isByHour?FontWeight.bold:FontWeight.normal
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 15,),

                input(
                    name:isByHour?"Renumeration par heure":"Renumeration par totale",
                    colorText: Colors.black,
                    fieldWidth: 110,
                    onChange: (val)=>calculFees(),
                    controller: priceController,
                    hint: '',
                    formatters: [
                      TextInputFormatter.withFunction(_numberFormatter)
                    ],
                    suffix:  SizedBox(
                        width: 10,
                        height: 20,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('€  ',style: GoogleFonts.inter(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),))),
                    validator: Validator().required().make()
                ),
                const SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Commision BUILMEET 10%',style: GoogleFonts.inter(fontWeight:FontWeight.bold,fontSize: 16,color: Colors.black),),
                    BlocBuilder<AddOfferBloc,AddOfferState>(
                        builder: (context,state){
                          return Text('${state.commision ?? ''}€',
                            style: GoogleFonts.inter(color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),);
                        }
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cout Totale de la mission',style: GoogleFonts.inter(fontSize: 16,color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                    BlocBuilder<AddOfferBloc,AddOfferState>(
                        builder: (context,state){
                          return Text('${state.totale ?? ''}€',
                            style: GoogleFonts.inter(color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),);
                        }
                    )
                  ],
                ),
                const SizedBox(height: 15,),
                MyCustomButton(name: 'Envoyer',textColor: Colors.white,borderRadius: 25,height: 50,onClick: _createOffer,),
                const SizedBox(height: 25,),



              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget input({required String name,
    required Color colorText,
    required double fieldWidth,
    required TextEditingController controller,
    required String hint,
    Widget? suffix,
    required String? Function(String?) validator,
    bool isReadOnly=false,
    VoidCallback? onSuffixClick,
    List<TextInputFormatter>? formatters,
    void Function(String?)? onChange
  }){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
          style: GoogleFonts.inter(color: colorText,fontSize: 16,fontWeight: FontWeight.bold),),
        SizedBox(
          width: fieldWidth,
          child: MyFormField(
            onChange: onChange,
            formatters: formatters,
            readOnly: isReadOnly,
            onSuffixClick: onSuffixClick,
            hint: hint,
            label: '',
            hintColor: Colors.grey,
            fillColor: Colors.white,
            inputType: TextInputType.number,
            borderRadius: 10,
            borderColor: AppColors.primaryColor.withOpacity(0.5),
            activeBorderColor: AppColors.primaryColor,
            suffix:suffix,
            validator:validator,
            controller: controller,
          ),
        )
      ],
    );
  }

  void onBack() {
    GoRouter.of(context).pop();
  }

  void _selectDateDebut()async {
    dateDebut=await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        currentDate: DateTime.now()
    );
    if(dateDebut!=null){
      String date=formatDate(dateDebut!);
      dateBeginController.text=date;
      calculFees();
    }
  }

  void _selectDateFin() async{
    dateFin=await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        currentDate: DateTime.now()
    );
    if(dateFin!=null){
      String date=formatDate(dateFin!);
      dateEndController.text=date;
      calculFees();
    }
  }


  void calculFees(){

    print('hello world');

    if(dateDebut!=null && dateFin!=null && dateDebut!.isAfter(dateFin!)){
      showDateWarning();
      return;
    }

    RegExp pattern=RegExp(r'^\d+\.$');

    String price=priceController.text;
    if(pattern.hasMatch(price)){
      price=price.replaceFirst('.', '');
    }

    BlocProvider.of<AddOfferBloc>(context).add(
        CalculeFees(
            nbHour: nbHourControler.text,
            dateBegin: dateDebut,
            dateEnd: dateFin,
            price: price,
            isByHour: isByHour)
    );



  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  TextEditingValue _numberFormatter(TextEditingValue oldValue, TextEditingValue newValue) {
    RegExp pattern1=RegExp(r'^\d+$');
    RegExp pattern2=RegExp(r'^\d+\.$');
    RegExp pattern3=RegExp(r'^\d+\.\d{1,2}$');
    if(newValue.text.isEmpty){
      return newValue;
    }
    if(pattern1.hasMatch(newValue.text) || pattern2.hasMatch(newValue.text) || pattern3.hasMatch(newValue.text)){
      return newValue;
    }
     return oldValue;
  }

  TextEditingValue _hoursPerDaysFormatter(TextEditingValue oldValue, TextEditingValue newValue) {
    RegExp pattern=RegExp(r'^\d+$');
    if(newValue.text.isEmpty){
      return newValue;
    }
    if(pattern.hasMatch(newValue.text) && int.parse(newValue.text)<=24 && int.parse(newValue.text)>0){
      return newValue;
    }
    return oldValue;
  }


  void _createOffer() {
    if(formState.currentState!.validate()){
      if(dateFin!.isAfter(dateDebut!)){

      }else{
        showDateWarning();
      }
    }
  }

  void showDateWarning() {
    showInfoDialogue(
        MessageUi('Date Fin should be\nafter date debut', AppStatus.warning, 'Okay'),
        context,
            () {hideDialogue(context); });
  }

}
