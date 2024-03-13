import 'dart:io';

import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/become_employee_bloc/become_employee_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:builmeet/presentation/ui/components/images_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';




class BecomeEmployeeSecreen extends StatefulWidget {




  BecomeEmployeeSecreen({Key? key}) : super(key: key);




  static Widget page(UserEntity userEntity){
    Repository repository=Dependencies.get<Repository>();
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
    return BlocProvider<BecomeEmployeeBloc>(
        create: (context)=>BecomeEmployeeBloc(repository: repository,sharedPrefService: sharedPrefService,userEntity: userEntity),
      child: BecomeEmployeeSecreen(),
    );
  }


  @override
  State<BecomeEmployeeSecreen> createState() => _BecomeEmployeeSecreenState();
}

class _BecomeEmployeeSecreenState extends State<BecomeEmployeeSecreen> {

  late TextEditingController metierController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> formState;

  late double width;
  late double height;



  @override
  void initState() {
    super.initState();
    metierController=TextEditingController();
    addressController=TextEditingController();
    descriptionController=TextEditingController();
    formState=GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.sizeOf(context).width;
    height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,),
        ),
        title: Text(
          getLang(context, "become_employee"),
          style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: formState,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Text(getLang(context, "become_employee_description"),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
                ),
                const SizedBox(height: 50,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<BecomeEmployeeBloc,BecomeEmployeeState>(
                      builder: (context,state){
                        if((state.metiers?.isNotEmpty ?? false)){
                          return Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,

                            children: List.generate(state.metiers!.length, (index) => metierElement(state.metiers!.elementAt(index), index)),
                          );
                        }
                        return SizedBox();
                      }
                  ),
                ),
                const SizedBox(height: 10,),

                MyFormField(
                    hint: getLang(context, "three_metier"),
                    label: '',
                    hintColor: Colors.grey,
                    fillColor: Colors.white,
                    borderColor: AppColors.primaryColor.withOpacity(0.5),
                    activeBorderColor: AppColors.primaryColor,
                    controller: metierController,
                    suffix:Icon(Icons.add,color: AppColors.primaryColor.withOpacity(0.5),),
                  onSuffixClick: _addMetier,
                ),
                const SizedBox(height: 10,),

                MyFormField(
                  hint: getLang(context, "offer_address"),
                  label: '',
                  validator: Validator().required().make(),
                  hintColor: Colors.grey,
                  fillColor: Colors.white,
                  borderColor: AppColors.primaryColor.withOpacity(0.5),
                  activeBorderColor: AppColors.primaryColor,
                  controller: addressController,
                ),
                const SizedBox(height: 10,),

                MyFormField(
                  hint: 'Description',
                  validator: Validator().required().make(),
                  label: '',
                  isLarge: true,
                  suffix: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.attach_file,color: Colors.grey,),
                    ],
                  ),
                  hintColor: Colors.grey,
                  fillColor: Colors.white,
                  borderColor: AppColors.primaryColor.withOpacity(0.5),
                  activeBorderColor: AppColors.primaryColor,
                  controller: descriptionController,
                  onSuffixClick: pickDocument,
                ),
                const SizedBox(height: 40,),
                BlocBuilder<BecomeEmployeeBloc,BecomeEmployeeState>(
                    builder: (context,state){
                      if(state.documents?.isNotEmpty ?? false){
                        return ImagesList(height: height*0.35,width: width,images: state.documents!);
                      }
                      return SizedBox();
                    }
                ),
                const SizedBox(height: 40,),

                MyCustomButton(name: getLang(context, "confirmer"),
                  height: 50,
                  borderRadius: 25,
                  color: AppColors.primaryColor,
                  onClick: confirmer,
                  fontSize: 18,),
                const SizedBox(height: 30,),
                BlocListener<BecomeEmployeeBloc,BecomeEmployeeState>(
                    listener: _listener,
                    child: SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget documentImage(File image){
    return Center(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          clipBehavior: Clip.hardEdge,
          constraints: BoxConstraints(
              maxWidth:width*0.7,
              maxHeight:height*0.3
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.grey,blurRadius: 10,offset: Offset(4,4))]
          ),
          child: Image.memory(image.readAsBytesSync(),fit: BoxFit.cover,)
      ),
    );
  }
  Widget metierElement(String item,int index){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(item,style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          IconButton(
              onPressed: ()=>deleteMetier(index),
              padding: EdgeInsets.zero,
              alignment:Alignment.centerRight,
              icon: const Icon(Icons.cancel_outlined,color: AppColors.primaryColor,))
        ],
      ),
    );
  }
  void deleteMetier(int index){
    BlocProvider.of<BecomeEmployeeBloc>(context).add(DeleteMetier(index));
  }

  void _addMetier() {
    print(metierController.text);
    BecomeEmployeeState state=BlocProvider.of<BecomeEmployeeBloc>(context).state;
    if(metierController.text.trim().isNotEmpty && (state.metiers?.length ?? 0)<3 ){
      BlocProvider.of<BecomeEmployeeBloc>(context).add(AddMetier(metierController.text));
      metierController.clear();
    }
  }

  void confirmer() {
    if(!formState.currentState!.validate()){
      return;
    }
    BecomeEmployeeState state=BlocProvider.of<BecomeEmployeeBloc>(context).state;
    if((state.metiers?.length ?? 0)==0) {
      showInfoDialogue(MessageUi(getLang(context, "metier_required"), AppStatus.warning, 'okay'), context, () {hideDialogue(context); });
      return;
    }
    BlocProvider.of<BecomeEmployeeBloc>(context).add(Confimer(addressController.text, descriptionController.text));
  }

  void pickDocument() {
    BlocProvider.of<BecomeEmployeeBloc>(context).add(PickDocument());
  }

  void _listener(BuildContext context, BecomeEmployeeState state) {
    if(state.becomeEmployeeStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.becomeEmployeeStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, () { hideDialogue(context);});
    }else if(state.becomeEmployeeStatus==AppStatus.success){
      hideDialogue(context);
      GoRouter.of(context).pop(state.userEntity);
    }
  }
}
