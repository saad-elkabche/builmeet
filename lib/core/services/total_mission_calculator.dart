



import 'package:builmeet/core/constants/enums.dart';

double calculTotalMission({
    required DateTime dateBegin,
    required DateTime dateEnd,
    required int nbHour,
    required double hourPrice,
    required UserTypes userType,
    required int commision}){
  int nbDays=dateEnd.difference(dateBegin).inDays;
  double total=nbDays*nbHour*hourPrice;
  if(userType==UserTypes.client){
    total=total*calculCommision(commision);
  }
  return total;
}

double calculCommision(int commision){
  return (1+(commision/100));
}