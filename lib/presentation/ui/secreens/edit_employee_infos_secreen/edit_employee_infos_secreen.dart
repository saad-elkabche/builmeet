import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/core/validator/validator.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/edit_employee_info_bloc/edit_employee_info_bloc.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


class EditEmployeeInfosSecreen extends StatefulWidget {

  static Widget page({required UserEntity userEntity}) {
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
    Repository  repository=Dependencies.get<Repository>();

    return BlocProvider<EditEmployeeInfoBloc>(
      create: (context) => EditEmployeeInfoBloc(userEntity: userEntity,sharedPrefService: sharedPrefService,repository: repository),
      child: EditEmployeeInfosSecreen(),
    );
  }


  EditEmployeeInfosSecreen({Key? key}) : super(key: key);

  @override
  State<EditEmployeeInfosSecreen> createState() =>
      _EditEmployeeInfosSecreenState();
}

class _EditEmployeeInfosSecreenState extends State<EditEmployeeInfosSecreen> {

  late TextEditingController metierController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late GlobalKey<FormState> formState;

  late double width;


  @override
  void initState() {
    super.initState();
    metierController = TextEditingController();
    addressController = TextEditingController();
    descriptionController = TextEditingController();
    formState = GlobalKey<FormState>();

    initializeValues();


  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.sizeOf(context).width;

    return BlocBuilder<EditEmployeeInfoBloc, EditEmployeeInfoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios, color: AppColors.primaryColor,),
            ),
            title: Text(
              'Update',
              style: GoogleFonts.inter(
                  color: AppColors.primaryColor, fontWeight: FontWeight.bold),
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
                    Text(
                      "Veuillez fournir toutes les informations nécessaires pour garantir une mise en relation optimale",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 50,),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: (state.metiers?.isNotEmpty ?? false)
                            ?
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,

                          children: List.generate(
                              state.metiers!.length, (index) =>
                              metierElement(
                                  state.metiers!.elementAt(index), index)),
                        )
                            :
                        const SizedBox()

                    ),
                    const SizedBox(height: 10,),

                    MyFormField(
                      hint: 'Métier 3 maximum',
                      label: '',
                      hintColor: Colors.grey,
                      fillColor: Colors.white,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      controller: metierController,
                      suffix: Icon(Icons.add,
                        color: AppColors.primaryColor.withOpacity(0.5),),
                      onSuffixClick:()=> _addMetier(state),
                    ),
                    const SizedBox(height: 10,),

                    MyFormField(
                      hint: 'Address',
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
                          Icon(Icons.attach_file, color: Colors.grey,),
                        ],
                      ),
                      hintColor: Colors.grey,
                      fillColor: Colors.white,
                      borderColor: AppColors.primaryColor.withOpacity(0.5),
                      activeBorderColor: AppColors.primaryColor,
                      controller: descriptionController,
                      onSuffixClick: _pickDocument,
                    ),
                    const SizedBox(height: 40,),
                    Container(
                        clipBehavior: Clip.hardEdge,
                        constraints: BoxConstraints(
                            maxWidth:width*0.9
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.grey,blurRadius: 10,offset: Offset(4,4))]
                        ),
                        child:state.document!=null
                            ?
                        Image.memory(
                          state.document!.readAsBytesSync(),
                          fit: BoxFit.cover,)
                            :
                            Image.network(state.userEntity!.documentPicUrl!,fit: BoxFit.cover,)
                    ),
                    const SizedBox(height: 40,),

                    MyCustomButton(name: 'Save',
                      height: 50,
                      borderRadius: 25,
                      color: AppColors.primaryColor,
                      onClick: _confirmer,
                      fontSize: 18,),
                    const SizedBox(height: 30,),
                    BlocListener<EditEmployeeInfoBloc, EditEmployeeInfoState>(
                      listener: _listener,
                      child: const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget metierElement(String item, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(item, style: GoogleFonts.inter(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),),
          IconButton(
              onPressed: () => _deleteMetier(index),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              icon: const Icon(
                Icons.cancel_outlined, color: AppColors.primaryColor,))
        ],
      ),
    );
  }


  void _addMetier(EditEmployeeInfoState state) {
    if(metierController.text.trim().isNotEmpty && (state.metiers?.length ?? 0)<3 ){
      BlocProvider.of<EditEmployeeInfoBloc>(context).add(AddMetier(metierController.text));
      metierController.clear();
    }
  }

  void _pickDocument() {
    BlocProvider.of<EditEmployeeInfoBloc>(context).add(PickImage());
  }

  void _confirmer() {

    if(formState.currentState!.validate()){
      List<String>? metiers = BlocProvider.of<EditEmployeeInfoBloc>(context).state.metiers;
      if((metiers ?? []).isNotEmpty){
        BlocProvider.of<EditEmployeeInfoBloc>(context).add(
            UpdateEmployeeInfos(addressController.text, descriptionController.text)
        );
      }else{
        showInfoDialogue(MessageUi('metier is required', AppStatus.warning, 'okay'), context, () {hideDialogue(context); });
      }
    }
  }

  void _listener(BuildContext context, EditEmployeeInfoState state) {
    if(state.editinfosStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.editinfosStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, () { hideDialogue(context);});
    }else if(state.editinfosStatus==AppStatus.success){
      hideDialogue(context);
      GoRouter.of(context).pop(state.userEntity);
    }
  }

  _deleteMetier(int index) {
    BlocProvider.of<EditEmployeeInfoBloc>(context).add(DeleteMetier(index));
  }

  void initializeValues() {
    EditEmployeeInfoState state = BlocProvider.of<EditEmployeeInfoBloc>(context).state;
    descriptionController.text=state.userEntity?.description ?? '';
    addressController.text=state.userEntity?.address ?? '';
  }
}
