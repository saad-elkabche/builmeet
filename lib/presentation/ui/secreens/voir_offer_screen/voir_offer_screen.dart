import 'package:builmeet/core/constants/app_colors.dart';
import 'package:builmeet/presentation/blocs/journal_bloc/journal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';



class VoirOfferScreen extends StatefulWidget {


  VoirOfferScreen({Key? key}) : super(key: key);

  static Widget page({required JournalBloc journalBloc}){
    return BlocProvider.value(
        value: journalBloc,
      child: VoirOfferScreen(),
    );
  }



  @override
  State<VoirOfferScreen> createState() => _VoirOfferScreenState();
}

class _VoirOfferScreenState extends State<VoirOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.scaffoldColor,
        title: Text('Details',style: GoogleFonts.inter(color: AppColors.primaryColor,fontSize: 20,fontWeight: FontWeight.bold),),
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
          icon:const  Icon(Icons.arrow_back_ios_new,color: AppColors.primaryColor,),),
      ),
      body: BlocBuilder<JournalBloc,JournalState>(
        builder: (context,state){
          return Column(
            children: [
              Text('Commande',style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)
            ],
          );
        },
      ),
    );
  }
}



