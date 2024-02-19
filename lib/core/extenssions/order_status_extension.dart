import 'package:builmeet/core/constants/enums.dart';

extension OrderStatusExtension on String{

  OrderStatus get orderStatus{
    switch(this){
      case 'active':return OrderStatus.active;
      case 'finished':return OrderStatus.finished;
      case 'pending':return OrderStatus.pending;
      default:throw Exception('unknown type!!');
    }
  }

}

extension OrderStatusStringExtension on OrderStatus{

  String get orderStatusString{
    switch(this){
      case OrderStatus.active:return 'active';
      case OrderStatus.finished:return 'finished';
      case OrderStatus.pending:return 'pending';
      default:throw Exception('unknown type!!');
    }
  }

}
