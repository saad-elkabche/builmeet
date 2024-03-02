


import 'package:builmeet/core/constants/enums.dart';

extension langsExtension on Langs{

  String get langCode{
    switch(this){
      case Langs.frensh:return 'fr';
      default:return 'en';
    }
  }

}

extension langsExtensionOnString on String{

  Langs get langCodeString{
    switch(this){
      case 'fr':return Langs.frensh;
      default:return Langs.english;
    }
  }

}

