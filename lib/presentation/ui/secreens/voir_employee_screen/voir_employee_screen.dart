import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/domain/entities/InterestEntity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/voir_employee_bloc/voir_employee_bloc.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/images_list.dart';
import 'package:builmeet/presentation/ui/components/shimming_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class VoirEmployeeScreen extends StatefulWidget {

  VoirEmployeeScreen({Key? key}) : super(key: key);


  static Widget page({required InterestEntity interestEntity}) {
    Repository repository = Dependencies.get<Repository>();
    return BlocProvider<VoirEmployeeBloc>(
      create: (context) =>
          VoirEmployeeBloc(
              repository: repository, interestEntity: interestEntity),
      child: VoirEmployeeScreen(),
    );
  }

  @override
  State<VoirEmployeeScreen> createState() => _VoirEmployeeScreenState();
}

class _VoirEmployeeScreenState extends State<VoirEmployeeScreen> {

  late double width;
  late double height;


  @override
  Widget build(BuildContext context) {
    width=MediaQuery.sizeOf(context).width;
    height=MediaQuery.sizeOf(context).height;

    return BlocBuilder<VoirEmployeeBloc, VoirEmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios, color: AppColors.primaryColor,),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text(
              '${state.interestEntity!.user!.nomComplet!}',
              style: GoogleFonts.inter(
                  color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height:20 ,),
                    profile(state),
                    const SizedBox(height:20 ,),
                    metiers(state),
                    const SizedBox(height:20 ,),
                    address(state),
                    const SizedBox(height:20 ,),
                    description(state),
                    const SizedBox(height:40 ,),
                    if(state.interestEntity!.interestStatus==InterestsStatus.pending)
                    actions(),
                    const SizedBox(height: 100,),
                    BlocListener<VoirEmployeeBloc,VoirEmployeeState>(
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
  Widget profile(VoirEmployeeState state){
   UserEntity userEntity=state.interestEntity!.user!;
    double rate=(state.interestEntity?.user?.rate ?? 0.0);
    String? imgProfile=state.interestEntity?.user?.profilePicUrl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imgProfile!=null
            ?
        MyCircleImage(width: 90, url: imgProfile)
            :
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(AppImages.img_person),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star,color: Colors.amber,),
            Text(rateCalculator(rate, userEntity.nbRates!),style: GoogleFonts.inter(color: Colors.amber,fontWeight: FontWeight.bold),),
            Text('(${userEntity.nbRates})',style: GoogleFonts.inter(color: Colors.grey,fontWeight: FontWeight.bold),)
          ],
        ),
        Text(userEntity.nomComplet!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
        Text('(${age(userEntity.dateNaissance!)} ${getLang(context,'ans')})',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),

      ],
    );
  }

  int age(DateTime dateNaissance){
    int daysPassed=DateTime.now().difference(dateNaissance).inDays;
    int age=(daysPassed/365).floor();
    return age;
  }

  Widget metiers(VoirEmployeeState state) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getLang(context, "metier"),style: GoogleFonts.inter(fontSize: 17,color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          ...List.generate(state.interestEntity!.user!.metiers!.length,
                  (index){
                    return Padding(
                        padding: EdgeInsets.only(left: 20,top: 10),
                      child: Text(state.interestEntity!.user!.metiers!.elementAt(index),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600),),
                    );
                  }
          )
        ],
      ),
    );
  }

  Widget address(VoirEmployeeState state) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          Text(getLang(context, "offer_address"),style: GoogleFonts.inter(fontSize: 17,color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          Padding(
            padding:const EdgeInsets.only(left: 20,top: 10),
            child: Text(state.interestEntity!.user!.address!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600),),
          )
        ],
      ),
    );
  }

  Widget description(VoirEmployeeState state) {

    List<String>? urls=state.interestEntity?.user?.documentPicUrls;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          Text('Description',style: GoogleFonts.inter(fontSize: 17,color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          Padding(
            padding:const EdgeInsets.only(left: 20,top: 10),
            child: Text(state.interestEntity!.user!.description!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600),),
          ),
          const SizedBox(height: 20,),
          if(urls?.isNotEmpty ?? false)
            ImagesList(height: height*0.35, width: width,urls: urls,)
        ],
      ),
    );
  }

  Widget actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyCustomButton(
          name: getLang(context, "refuser"),
          fontSize: 18,
          borderRadius: 23,
          width: 150,
          height: 45,
          hasBorder: true,
          borderColor: AppColors.primaryColor,
          textColor: AppColors.primaryColor,
          onClick: _refuserInterest,
          color: AppColors.scaffoldColor,),
        MyCustomButton(
          name: getLang(context, "accepter"),
          fontSize: 18,
          borderRadius: 23,
          width: 150,
          height: 45,
          textColor: Colors.white,
          onClick: _accepterInterest,
          color: AppColors.primaryColor,),
      ],
    );
  }



  void _refuserInterest() {
    BlocProvider.of<VoirEmployeeBloc>(context).add(RefuseInterest());
  }

  void _accepterInterest() {
    BlocProvider.of<VoirEmployeeBloc>(context).add(AcceptInterest());
  }

  void _listener(BuildContext context, VoirEmployeeState state) {
    if(state.operationStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.operationStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('error', AppStatus.error, 'Okay'), context, () { hideDialogue(context);});
    }else if(state.operationStatus==AppStatus.success){
      hideDialogue(context);
    }
  }
}
