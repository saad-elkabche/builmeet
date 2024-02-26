import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/edit_employee_info_bloc/edit_employee_info_bloc.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:builmeet/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:builmeet/presentation/ui/secreens/profile_screen/components/info_item.dart';
import 'package:builmeet/presentation/ui/secreens/profile_screen/components/profile_header.dart';
import 'package:builmeet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';





class ProfileScreen extends StatefulWidget {


  ProfileScreen({Key? key}) : super(key: key);


  static Widget page(){

    Repository repository=Dependencies.get<Repository>();
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();

    return BlocProvider<ProfileBloc>(
        create: (context)=>ProfileBloc(repository, sharedPrefService),
      child: ProfileScreen(),
    );
  }



  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late double width;
  late double height;




  @override
  Widget build(BuildContext context) {

    width=MediaQuery.sizeOf(context).width;
    height=MediaQuery.sizeOf(context).height;

    return BlocBuilder<ProfileBloc,ProfileState>(
        builder: (context,state){
          return Scaffold(
            backgroundColor: Colors.white,
            body:  Center(
                child:Column(
                  children: [

                    header(state),
                    const SizedBox(height: 30,),
                    BlocListener<ProfileBloc,ProfileState>(
                      listener: _listener,
                      child: SizedBox(),
                    ),

                    Expanded(
                        child:SingleChildScrollView(
                          child: Column(
                            children: [
                              employeeSwitcher(state),
                          
                              name(state),
                              email(state),
                              password(state),
                              langs(state),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                height: 1.5,
                                color: AppColors.primaryColor.withOpacity(0.2),
                              ),
                          
                              if(state.appMode==UserTypes.employee)...[
                                jobs(state),
                                address(state),
                                description(state),
                              ],
                          
                              const SizedBox(height: 50,),
                              devenirUnPrestataire(state),
                              const SizedBox(height: 10,),
                              deconnecter(state),
                              const SizedBox(height: 90,),
                            ],
                          ),
                        )
                    ),




                  ],
                )
            ),
          );
        }
    );
  }



  @override
  void initState() {
    super.initState();
    _fetchData();
  }



  Widget header(ProfileState state) {

    if(state.fetchingDataStatus==AppStatus.loading){
      return ProfileHeader(isLoading: true,);
    }else if(state.fetchingDataStatus==AppStatus.error){
      return const SizedBox();
    }else if(state.fetchingDataStatus==AppStatus.success){
      return ProfileHeader(
        name: state.userEntity!.nomComplet,
        url: state.userEntity!.profilePicUrl,
        pickImage: pickImage,
      );
    }
    return SizedBox();
  }



  Widget employeeSwitcher(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.success && state.userEntity!.type==UserTypes.employee){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mode Prestataire',style:GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17) ,),
            Switch(
                value: state.appMode==UserTypes.employee,
                activeColor: Colors.white,
                activeTrackColor:AppColors.primaryColor,
                inactiveTrackColor: AppColors.scaffoldColor,
                inactiveThumbColor: AppColors.primaryColor,
                trackOutlineColor: MaterialStateColor.resolveWith((states) => Colors.white),
                trackOutlineWidth: MaterialStateProperty.resolveWith((states) => 0),
                onChanged: (value){
                  setAppMode(value);
                  BlocProvider.of<MainScreenBloc>(context).add(NotifyAppModeChanged());
                }
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  void setAppMode(bool value) {
    BlocProvider.of<ProfileBloc>(context).add(SetAppMode(value));
  }
  Widget metierElement(String item){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(item,style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
  Widget name(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.loading){
      return InfoItem(isLoading: true,);
    }else if(state.fetchingDataStatus==AppStatus.success){
      return InfoItem(
        icon: Icons.person_2_rounded,
        info: state.userEntity!.nomComplet,
        onEdit: editName,
      );
    }
    return const SizedBox();
  }
  Widget email(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.loading){
      return InfoItem(isLoading: true,);
    }else if(state.fetchingDataStatus==AppStatus.success){
      return InfoItem(
        icon: Icons.email_outlined,
        info: state.userEntity!.adressEmail,
        onEdit: editEmail,
      );
    }
    return const SizedBox();
  }
  Widget password(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.loading){
      return InfoItem(isLoading: true,);
    }else if(state.fetchingDataStatus==AppStatus.success){
      return InfoItem(
        icon: Icons.lock_open,
        info: 'Password',
        onEdit: editPassword,
      );
    }
    return const SizedBox();
  }
  Widget langs(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.loading){
      return InfoItem(isLoading: true,);
    }else if(state.fetchingDataStatus==AppStatus.success){
      return InfoItem(
        icon: Icons.language_sharp,
        info: 'Language',
      );
    }
    return const SizedBox();
  }
  Widget jobs(ProfileState state) {
   if(state.fetchingDataStatus==AppStatus.loading){
     return InfoItem(
       isLoading: true,
     );
   }else if(state.fetchingDataStatus==AppStatus.success){
     return InfoItem(
       icon: FontAwesomeIcons.donate,
       info: 'Metiers',
       onEdit: _navToEditEmployeeInfos,
       subInfo: Wrap(
         alignment: WrapAlignment.start,
         crossAxisAlignment: WrapCrossAlignment.start,
         children: List.generate(state.userEntity?.metiers?.length ?? 0, (index) => metierElement(state.userEntity!.metiers!.elementAt(index))),
       ),
     );
   }
   return const SizedBox();
  }
  Widget address(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.loading){
      return InfoItem(
        isLoading: true,
      );
    }else if(state.fetchingDataStatus==AppStatus.success){

      return InfoItem(
        withIcon: false,
        icon: Icons.location_city,
        info:'Address',
        subInfo: state.userEntity?.address,
      );
    }
    return const SizedBox();
  }
  Widget description(ProfileState state) {
    print('=============AppMode==================${state.appMode}');
    if(state.fetchingDataStatus==AppStatus.loading){
      return InfoItem(
        isLoading: true,
      );
    }else if(state.fetchingDataStatus==AppStatus.success){

      return descriptionWidget(state.userEntity!.description!,state.userEntity?.documentPicUrl );
    }
    return const SizedBox();
  }

  Widget devenirUnPrestataire(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.success && state.userEntity!.type==UserTypes.client){
      return MyCustomButton(
        name: 'Devenir Prestataire',
        color: Colors.white,
        hasBorder: true,
        height: 50,
        borderRadius: 25,
        onClick: navToBecomeAnEmployee,
        textColor: AppColors.primaryColor,
        fontSize: 20,
        borderColor: AppColors.primaryColor,);
    }
    return const SizedBox();
  }

  Widget deconnecter(ProfileState state) {
    if(state.fetchingDataStatus==AppStatus.success){
      return MyCustomButton(
        name: 'Se déconnecté',
        color: AppColors.primaryColor,
        hasBorder: true,
        height: 50,
        borderRadius: 25,
        textColor: Colors.white,
        fontSize: 20,
        onClick: logout,
        borderColor: AppColors.primaryColor,);
    }
    return const SizedBox();
  }
  Widget descriptionWidget(String description,String? url){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text('Description',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text('$description',style: GoogleFonts.inter(color: Colors.grey,fontWeight: FontWeight.normal),),
        ),
        const SizedBox(height: 10,),
        if(url!=null)
          Container(
              clipBehavior: Clip.hardEdge,
              constraints: BoxConstraints(
                  maxWidth: width*0.9
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.grey,blurRadius: 10,offset: Offset(4,4))]
              ),
              child: Image.network(url,fit: BoxFit.cover,)
          )
      ],
    );
  }
  Widget dialogue(Widget child,String action){
    GlobalKey<FormState> formsState=GlobalKey<FormState>();
    return Center(
      child: Container(
        width: width*0.9,
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          child: Form(
            key: formsState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: width*0.9,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          action,
                          style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                      ),
                      Center(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:IconButton(
                            icon: const Icon(Icons.cancel_outlined,color: AppColors.primaryColor,),
                            onPressed:()=> Navigator.of(context,rootNavigator: true).pop(false),
                          )
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                child,
                const SizedBox(height: 30,),
                MyCustomButton(name: 'Save',
                    height: 40,
                    borderRadius: 20,
                    color: AppColors.primaryColor,
                    onClick: (){
                      if(formsState.currentState!.validate()){
                        Navigator.of(context,rootNavigator: true).pop(true);
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }














  void _listener(BuildContext context, ProfileState state) {
    if(state.updateStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.updateStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi(state.error ?? 'Error', AppStatus.error, 'try again'), context, () {hideDialogue(context) ;});
    }else if(state.updateStatus==AppStatus.success){
      hideDialogue(context);
      showInfoDialogue(MessageUi(state.message ?? 'success', AppStatus.success, 'Okay'), context, () {
        if(state.intent==ProfileState.updateEmailIntent || state.intent==ProfileState.updatePasswordIntent){
          BlocProvider.of<ProfileBloc>(context).add(Logout());
        }else{
         hideDialogue(context);
        }

      });
    }
  }
  void pickImage() {
    BlocProvider.of<ProfileBloc>(context).add(PickImageProfle());
  }
  void editName()async{
    TextEditingController nameController=TextEditingController();
    var result=await showDialog(
        context: context,
        builder: (context){
          return dialogue(
              MyFormField(
                hint: 'Name',
                label: '',
                borderRadius: 15,
                borderColor: AppColors.primaryColor.withOpacity(0.5),
                activeBorderColor: AppColors.primaryColor,
                validator: Validator()
                    .required()
                    .min(4)
                    .make(),
                fillColor: Colors.white,
                controller: nameController,
              ),
              'Update Name'
          );
        }
    );
    if(result ?? false){
      BlocProvider.of<ProfileBloc>(context).add(UpdateName(nameController.text));
    }
  }
  void editEmail()async{
    TextEditingController emailController=TextEditingController();
    var result=await showDialog(
        context: context,
        builder: (context){
          return dialogue(
              MyFormField(
                hint: 'Email',
                label: '',
                borderRadius: 15,
                borderColor: AppColors.primaryColor.withOpacity(0.5),
                activeBorderColor: AppColors.primaryColor,
                validator: Validator()
                    .required()
                    .email()
                    .make(),
                fillColor: Colors.white,
                controller: emailController,
              ),
              'Update Email'
          );
        }
    );
    if(result ?? false){
      print(emailController.text);
      BlocProvider.of<ProfileBloc>(context).add(UpdateEmail(emailController.text));
    }
  }
  void editPassword()async{
    TextEditingController passController=TextEditingController();
    var result=await showDialog(
        context: context,
        builder: (context){
          return dialogue(
              MyFormField(
                hint: 'Password',
                label: '',
                isPassWord: true,
                openEyeIcon: const Icon(Icons.remove_red_eye_outlined,color: AppColors.primaryColor,),
                closeEyeIcon: const Icon(FontAwesomeIcons.eyeSlash,color: AppColors.primaryColor,),
                borderRadius: 15,
                borderColor: AppColors.primaryColor.withOpacity(0.5),
                activeBorderColor: AppColors.primaryColor,
                validator: Validator()
                    .required()
                    .min(8)
                    .make(),
                fillColor: Colors.white,
                controller: passController,
              ),
              'Update Password'
          );
        }
    );
    if(result ?? false){
      BlocProvider.of<ProfileBloc>(context).add(UpdatePassword(passController.text));
    }
  }

  void _fetchData() {
    BlocProvider.of<ProfileBloc>(context).add(FetchProfileData());
  }
  void logout() async{
    BlocProvider.of<ProfileBloc>(context).add(Logout());
  }
  void navToBecomeAnEmployee() async{
    ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    UserEntity userEntity=profileBloc.state.userEntity!;
    var result=await GoRouter.of(context).push(Routes.becomeEmployee,extra: userEntity);
    if(result is UserEntity){
      profileBloc.add(RefreshData(result));
      BlocProvider.of<MainScreenBloc>(context).add(NotifyAppModeChanged());
    }
  }

  void _navToEditEmployeeInfos() async{
    ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    UserEntity userEntity=profileBloc.state.userEntity!;
    var result = await GoRouter.of(context).push(Routes.editEmployeeInfos,extra: userEntity);
    if(result is UserEntity){
      profileBloc.add(RefreshData(result));
    }
  }
}


