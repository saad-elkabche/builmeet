


import 'package:builmeet/core/constants/enums.dart';

extension PricingTypeExtension on String{

  PricingTypes get pricingType{
    switch(this){
      case 'hourly':return PricingTypes.hourly;
      case 'total':return PricingTypes.total;
      default:
        throw Exception('unknown type!!');
    }
  }

}


extension PricingTypeStringException on PricingTypes{

  String get pricingTypesString{
    switch(this){
      case PricingTypes.hourly:return 'hourly';
      case PricingTypes.total:return 'total';
      default:
        throw Exception('unknown type!!');
    }
  }

}