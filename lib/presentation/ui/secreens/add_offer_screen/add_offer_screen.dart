import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/add_offer_bloc/add_offer_bloc.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:builmeet/presentation/ui/secreens/add_offer_screen/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';




class AddOfferScreen extends StatefulWidget {



  AddOfferScreen({Key? key}) : super(key: key);

  static Widget page(){
    Repository repository=Dependencies.get<Repository>();
    return BlocProvider<AddOfferBloc>(
        create: (context)=>AddOfferBloc(repository: repository),
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
                    hint: getLang(context, "metier_requis"),
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
                  hint: getLang(context,"add_offer_description" ),
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
                  hint: getLang(context, "offer_address"),
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

                input(name: getLang(context, "nb_hour_per_jour"),
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

                input(name: getLang(context, "date_begin"),
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

                input(name: getLang(context, "date_end"),
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
                    Text(getLang(context, "remuneration"),
                      style: GoogleFonts.inter(color: AppColors.primaryColor,fontSize: 16,fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getLang(context, "total"),
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
                        Text(getLang(context, "hour"),
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
                    name:isByHour?getLang(context, "rem_per_hour"):getLang(context, "rem_per_totale"),
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
                    Text(getLang(context, "commission_builmet"),style: GoogleFonts.inter(fontWeight:FontWeight.bold,fontSize: 16,color: Colors.black),),
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
                    Text(getLang(context, "total_price"),style: GoogleFonts.inter(fontSize: 16,color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
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
                MyCustomButton(name: getLang(context, "send"),textColor: Colors.white,borderRadius: 25,height: 50,onClick: _createOffer,),
                const SizedBox(height: 25,),

                BlocListener<AddOfferBloc,AddOfferState>(
                  listener: _AddOfferListener,
                  child: SizedBox(),
                )
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
      //return;
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
    if(!formState.currentState!.validate()) {
      return;
    }
    if(!dateFin!.isAfter(dateDebut!)){
      showDateWarning();
      return;
    }

    BlocProvider.of<AddOfferBloc>(context).add(CreateOffer(

        address: addressController.text,
        description: descriptionController.text,
        metier: metierController.text,
        nbHour: nbHourControler.text,
        dateBegin: dateDebut!,
        dateEnd: dateFin!,
        price: priceController.text,
        isByHour: isByHour
      )
    );
  }


  void showDateWarning() {
    showInfoDialogue(
        MessageUi(getLang(context, "date_error"), AppStatus.warning, 'Okay'),
        context,
            () {hideDialogue(context); });
  }



  void _AddOfferListener(BuildContext context, AddOfferState state) {
    if(state.addOfferStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.addOfferStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi(state.error??'error', AppStatus.error, 'Okay'), context, () {hideDialogue(context); });
    }else if(state.addOfferStatus==AppStatus.success){
      hideDialogue(context);
      showInfoDialogue(MessageUi(getLang(context, "offer_created"), AppStatus.success, 'Okay'), context, () {
        hideDialogue(context);
        GoRouter goRouter=GoRouter.of(context);
        while(goRouter.canPop()){
          goRouter.pop(true);
        }
      });
    }
  }
}
