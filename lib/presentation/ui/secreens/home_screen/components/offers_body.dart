import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/offer_widget_client.dart';
import 'package:builmeet/presentation/ui/secreens/home_screen/components/offer_widget_employee.dart';
import 'package:flutter/material.dart';




class OffersBody extends StatelessWidget {
  List<OfferEntity>? offers;
  bool? isLoading;
  UserTypes appMode;

  void Function(OfferEntity)? onInterss;
  void Function(OfferEntity,int)? onPasInterss;
  void Function(OfferEntity)? onLesIntersses;
  void Function(OfferEntity)? onStop;




   OffersBody({required this.appMode,
     this.onPasInterss,
     this.onInterss,
     this.onStop,
     this.onLesIntersses,
     this.isLoading,
     this.offers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: appMode==UserTypes.client
          ?
      List.generate(
          (isLoading ?? false)?3:offers!.length,
           (index) => OfferWidgetClient(
             offerEntity: offers?.elementAt(index),
             onStopClick: onStop,
             onInterestClick: onLesIntersses,
             isloading: isLoading,
           )
      )
          :
      List.generate((isLoading ?? false)?3:offers!.length,
              (index) => OfferWidgetEmployee(
                index: index,
                offerEntity: offers?.elementAt(index),
                isloading: isLoading,
                onInteress: onInterss,
                onPasInterss: onPasInterss,
              )
      ),
    );
  }
}
