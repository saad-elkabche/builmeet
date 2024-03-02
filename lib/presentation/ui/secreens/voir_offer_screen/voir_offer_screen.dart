import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/core/constants/app_images_icons.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/local_service/applocal.dart';
import 'package:builmeet/core/services/rates_calculator.dart';
import 'package:builmeet/core/utils/show_dialogue_infos.dart';
import 'package:builmeet/core/utils/show_progress_dialogue.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/journal_bloc/journal_bloc.dart';
import 'package:builmeet/presentation/blocs/voir_offer_bloc/voir_offer_cubit.dart';
import 'package:builmeet/presentation/ui/components/circle_image.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:builmeet/presentation/ui/components/dialogue_infos.dart';
import 'package:builmeet/presentation/ui/components/shimming_widget.dart';
import 'package:builmeet/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';



class VoirOfferScreen extends StatefulWidget {


  VoirOfferScreen({Key? key}) : super(key: key);

  static Widget page({required OfferEntity offer}){
    Repository repository=Dependencies.get<Repository>();

    return BlocProvider<VoirOfferCubit>(
      create: (context)=>VoirOfferCubit(repository: repository, offerEntity: offer),
      child: VoirOfferScreen(),
    );
  }



  @override
  State<VoirOfferScreen> createState() => _VoirOfferScreenState();
}

class _VoirOfferScreenState extends State<VoirOfferScreen> {

  late double width;

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.scaffoldColor,
        title: Text(getLang(context, "details"),style: GoogleFonts.inter(color: AppColors.primaryColor,fontSize: 20,fontWeight: FontWeight.bold),),
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
          icon:const  Icon(Icons.arrow_back_ios_new,color: AppColors.primaryColor,),),
      ),
      body: BlocBuilder<VoirOfferCubit,VoirOfferState>(
        builder: (context,state){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocListener<VoirOfferCubit,VoirOfferState>(
                      listener:_listenner,
                    child: SizedBox(),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getLang(context, "Order"),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
                  const SizedBox(height: 30,),
                  Container(
                    width: width*0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item(getLang(context, "metier_requis"), state.offerEntity!.metier),
                        item('Description', state.offerEntity!.description),
                        item(getLang(context, "adress"), state.offerEntity!.address),
                        listTile(
                            const Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                            '${getLang(context, 'de')} ${dateFormatter(state.offerEntity!.dateDebut!)} ${getLang(context, 'a')} ${dateFormatter(state.offerEntity!.dateFin!)}'
                        ),
                        listTile(const Icon(Icons.timer_outlined,color: AppColors.primaryColor,),'${state.offerEntity!.nbHourPerDay}${getLang(context, "hour_jour")}'),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Text(getLang(context, "remuneration"),style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                            Text('${(state.offerEntity!.price! * 1.1)} €',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold),),
                          ],
                        ),
              
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getLang(context, "prestataire"),style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
              
                  const SizedBox(height: 20,),
                  Container(
                    width: width*0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment:Alignment.center,
                            child: profile(state)),
                        item(getLang(context, "metier"),metiers(state)),
                        item(getLang(context, "adress"), state.offerEntity!.employee!.address),
                        description(state)

                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  getAction(state),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  String metiers(VoirOfferState state){
    String metiers='';
    state.offerEntity!.employee!.metiers!.forEach((element) { metiers+='$element\n';});
    return metiers;
  }
  Widget description(VoirOfferState state) {

    String? documentUrl=state.offerEntity?.employee?.documentPicUrl;

    UserEntity employee=state.offerEntity!.employee!;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          Text('Description',style: GoogleFonts.inter(fontSize: 17,color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
          Padding(
            padding:const EdgeInsets.only(left: 20,top: 10),
            child: Text(employee.description!,style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w600),),
          ),
          const SizedBox(height: 20,),
          if(documentUrl!=null)
            Container(
              clipBehavior: Clip.hardEdge,
              constraints: BoxConstraints(
                  maxWidth: width*0.88
              ),
              decoration:  BoxDecoration(
                  boxShadow:const [BoxShadow(color: Colors.grey,blurRadius: 10,offset: Offset(3,3))] ,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: CachedNetworkImage(
                imageUrl: documentUrl,
                errorWidget:(context,str,obj)=>const Icon(Icons.image,color: Colors.red,),
                placeholder: (ctx,str)=>ShimmingWidget(
                    width:width*0.8,
                    baseColor: Colors.grey[200],
                    shimmingColor: AppColors.primaryColor,
                    height:width*0.8),
              ),
            )
        ],
      ),
    );
  }


  Widget profile(VoirOfferState state){
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        state.offerEntity?.employee?.profilePicUrl!=null
            ?
        MyCircleImage(
          width: 80,
          url: state.offerEntity!.employee!.profilePicUrl!,
        )
            :
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(AppImages.img_person),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star,color: Colors.amber,),
            Text(rateCalculator((state.offerEntity?.employee?.rate) ?? 0, (state.offerEntity?.employee?.nbRates ?? 0)),
              style: GoogleFonts.inter(color: Colors.amber),),
            Text('(${state.offerEntity?.employee?.nbRates ?? 0})',style: GoogleFonts.inter(color: Colors.grey),)
          ],
        ),
        const SizedBox(height: 10,),
        Text(state.offerEntity!.employee!.nomComplet!,style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold),),
        const SizedBox(height: 10,),
        Text('(${age(state.offerEntity!.employee!.dateNaissance!).toString()})',style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold),),
      ],
    );
  }
  
  int age(DateTime dateNaissance){
    int nbDays=DateTime.now().difference(dateNaissance).inDays;
    return (nbDays/365).floor();
  }

  String dateFormatter(DateTime date){
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget listTile(Widget icon,String title){
    return ListTile(
      leading: icon,
      title:Text(title,
        style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w400),),
    );
  }

  Widget item(String name,value){
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name',style: GoogleFonts.inter(color: AppColors.primaryColor,fontWeight:FontWeight.bold ),),
          const SizedBox(height: 12,),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('$value',style: GoogleFonts.inter(color: Colors.black,fontWeight:FontWeight.bold ),)),
        ],
      ),
    );
  }

  Widget getAction(VoirOfferState state) {
    if(state.offerEntity!.orderStatus!=OrderStatus.finished){
      return MyCustomButton(
        name:getLang(context, "terminer"),
        color: AppColors.primaryColor,
        width: 150,
        horizontalMargin: 0,
        textColor: Colors.white,
        borderRadius: 23,
        height: 45,
        fontSize: 16,
        onClick:finishOffer,
      );
    }
    return const SizedBox();
  }



  void finishOffer() {
    BlocProvider.of<VoirOfferCubit>(context).finishOffer();
  }

  void _listenner(BuildContext context, VoirOfferState state) {
    if(state.finishOfferStatus==AppStatus.loading){
      showProgressBar(context);
    }else if(state.finishOfferStatus==AppStatus.error){
      hideDialogue(context);
      showInfoDialogue(MessageUi('Error', AppStatus.error, 'Okay'), context, (){hideDialogue(context);});
    }else if(state.finishOfferStatus==AppStatus.success){
      hideDialogue(context);
      GoRouter.of(context).push(Routes.ratingScreen,extra: state.offerEntity);
    }
  }
}



