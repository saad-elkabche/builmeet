

import 'dart:ui';

import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/langs_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';

class LocalController{

  late Locale _currentLocal;
  VoidCallback? listenner;
  SharedPrefService sharedPrefService;


  LocalController({required this.sharedPrefService}){
    String langCode;
    if(sharedPrefService.contains(SharedPrefService.app_lang)) {
      langCode = sharedPrefService.getValue(
          SharedPrefService.app_mode, Langs.english.langCode);
    }else{
      langCode=Langs.frensh.langCode;
    }
    _currentLocal=Locale(langCode);
  }

  void changelang(Langs lang){
    _currentLocal=Locale(lang.langCode);
    sharedPrefService.putValue(SharedPrefService.app_lang, lang.langCode);
    listenner?.call();
  }

  void addListenner(VoidCallback listenner){
    this.listenner=listenner;
  }

  Locale get currentLocal=>_currentLocal;


}
