import 'package:builmeet/core/constants/enums.dart';


extension InterestsStatusExtension on String{

  InterestsStatus get interestStatus{
    switch(this){
      case 'pending':return InterestsStatus.pending;
      case 'accepted':return InterestsStatus.accepted;
      case 'refused':return InterestsStatus.refused;
      case 'taken':return InterestsStatus.taken;
      default:throw Exception('unknown type!!');
    }
  }

}

extension InterestStatusString on InterestsStatus{

  String get interestStatusString{
    switch(this){
      case InterestsStatus.pending:return 'pending';
      case InterestsStatus.accepted:return 'accepted';
      case InterestsStatus.refused:return 'refused';
      case InterestsStatus.taken:return 'taken';
      default:throw Exception('unknown type!!');
    }
  }

}
