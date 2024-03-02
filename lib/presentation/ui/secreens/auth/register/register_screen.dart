
import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_strings.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/auth/register_bloc/register_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:builmeet/presentation/ui/components/text_button.dart';
import 'package:builmeet/presentation/ui/secreens/auth/register/components/profile_pic.dart';
import 'package:builmeet/presentation/ui/secreens/main_screen/main_screen.dart';
import 'package:builmeet/routes.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';





class RegisterSecren extends StatefulWidget {

  static Widget page(){
    Repository repository=Dependencies.get<Repository>();
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
    return BlocProvider<RegisterBloc>(
      create: (context)=>RegisterBloc(sharedPrefService: sharedPrefService,repository: repository),
      child:RegisterSecren() ,
    );
  }

  RegisterSecren({Key? key}) : super(key: key);

  @override
  State<RegisterSecren> createState() => _RegisterSecrenState();
}

class _RegisterSecrenState extends State<RegisterSecren> {

  late TextEditingController nomComplete;
  late TextEditingController dateNaissance;
  late TextEditingController addressEmail;
  late TextEditingController motPass;
  late TextEditingController confirmMotPass;

  late GlobalKey<FormState> formState;
  DateTime? selectedDate;


  @override
  void initState() {
    super.initState();

    nomComplete=TextEditingController();
    dateNaissance=TextEditingController();
    addressEmail=TextEditingController();
    motPass=TextEditingController();
    confirmMotPass=TextEditingController();
    formState=GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<RegisterBloc,RegisterState>(
                      builder:(context,state)=>ProfilePic(onPickImage: pickProfImage,image:state.profImage)),
                  const SizedBox(height: 20,),
                  MyFormField(
                      borderRadius: 10,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      fillColor: Colors.white,
                      hint: getLang(context, "nom_complete"),
                      hintColor: Colors.grey,
                      controller: nomComplete,
                      validator: Validator()
                                 .required()
                                 .min(4)
                                 .max(20)
                                 .make(),
                      label: ''),
                  const SizedBox(height: 20,),
                  MyFormField(
                      borderRadius: 10,
                      readOnly: true,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      fillColor: Colors.white,
                      hint: getLang(context, "date_naissance"),
                      suffix: const Icon(Icons.calendar_month,color: Colors.grey,),
                      hintColor: Colors.grey,
                      onSuffixClick: pickDateNaissance,
                      controller: dateNaissance,
                      validator: Validator()
                          .required()
                          .make(),
                      label: ''),
                  const SizedBox(height: 20,),
                  MyFormField(
                      borderRadius: 10,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      fillColor: Colors.white,
                      hint: getLang(context, "addr_email"),
                      controller: addressEmail,
                      validator: Validator()
                          .required()
                          .email()
                          .make(),
                      hintColor: Colors.grey,
                      label: ''),
                  const SizedBox(height: 20,),
                  MyFormField(
                      borderRadius: 10,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      fillColor: Colors.white,
                      hint: getLang(context, "mot_pass"),
                      hintColor: Colors.grey,
                      controller: motPass,
                      isPassWord: true,
                      validator: Validator()
                          .required()
                          .contains([Components.letters,Components.numbers])
                          .max(15)
                          .min(8)
                          .make(),
                      suffix: const Icon(Icons.remove_red_eye_rounded,color: AppColors.primaryColor,),
                      openEyeIcon: const Icon(Icons.remove_red_eye_rounded,color: AppColors.primaryColor,),
                      closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: AppColors.primaryColor,),
                      label: ''),
                  const SizedBox(height: 20,),
                  MyFormField(
                      borderRadius: 10,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      fillColor: Colors.white,
                      hintColor: Colors.grey,
                      hint: getLang(context, "confirm_mot_pass"),
                      controller: confirmMotPass,
                      isPassWord: true,
                      openEyeIcon: const Icon(Icons.remove_red_eye_rounded,color: AppColors.primaryColor,),
                      closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: AppColors.primaryColor,),
                      validator: Validator()
                          .required()
                          .confirmPass(motPass)
                          .make(),
                      label: ''),
                  const SizedBox(height: 40,),

                  MyCustomButton(name:getLang(context, "register"),
                    color: AppColors.primaryColor,
                    borderRadius: 25,
                    height: 50,
                    onClick: register,
                    fontSize: 25,),
                  const SizedBox(height: 20,),
                  MyTextButton(name: getLang(context, "you_hav_an_account"), color: AppColors.primaryColor,onclick: navToLogin,),
                  BlocListener<RegisterBloc,RegisterState>(
                      listener: _listernner,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void pickProfImage(){
    BlocProvider.of<RegisterBloc>(context).add(PickImage());
  }


  void register() {
    if(formState.currentState!.validate()){
      BlocProvider.of<RegisterBloc>(context).add(UserRegister(nomComplete.text,
      selectedDate!,
      addressEmail.text,
      motPass.text));
    }
  }

  void pickDateNaissance() async{
    selectedDate=await showDatePicker(context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year-6),
      //currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: getLang(context, "date_naissance"),
    );

    if(selectedDate!=null){
      dateNaissance.text=Dependencies.get<DateFormat>().format(selectedDate!);
    }
  }

  void navToLogin() {
    GoRouter.of(context).pop();
  }

  void _listernner(BuildContext context, RegisterState state) {
    if(state.registerStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.registerStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi(getLang(context,state.error ?? 'error'), AppStatus.error, 'Okay'), context, () {hideDialogue(context); });
    }else if(state.registerStatus==AppStatus.success){
      GoRouter goRouter = GoRouter.of(context);
      while(goRouter.canPop()){
        goRouter.pop();
      }
      GoRouter.of(context).pushReplacement(Routes.home);
    }
  }
}
