import 'package:builmeet/core/constants/enums.dart';


extension InterestsStatusExtension on String{

  InterestsStatus get orderStatus{
    switch(this){
      case 'pending':return InterestsStatus.pending;
      case 'accepted':return InterestsStatus.accepted;
      case 'refused':return InterestsStatus.refused;
      default:throw Exception('unknown type!!');
    }
  }

}

extension InterestStatusString on InterestsStatus{

  String get interestStatusString{
    switch(this){
      case InterestsStatus.pending:return 'active';
      case InterestsStatus.accepted:return 'accepted';
      case InterestsStatus.refused:return 'refused';
      default:throw Exception('unknown type!!');
    }
  }

}
