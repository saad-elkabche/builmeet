



import 'package:builmeet/core/constants/enums.dart';

double calculTotalMission({
    required DateTime dateBegin,
    required DateTime dateEnd,
    required int nbHour,
    required double hourPrice,}){

  int nbDays=dateEnd.difference(dateBegin).inDays+1;
  double total=nbDays*nbHour*hourPrice;
  return total;
}

double calculCommision(int commision){
  return (1+(commision/100));
}