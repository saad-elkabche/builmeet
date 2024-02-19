part of 'add_offer_bloc.dart';

@immutable
abstract class AddOfferEvent {}


class CalculeFees extends AddOfferEvent{
  String nbHour;
  DateTime? dateBegin;
  DateTime? dateEnd;
  String price;
  bool isByHour;

  CalculeFees({
    required this.nbHour,
    this.dateBegin,
    this.dateEnd,
    required this.price,
    required this.isByHour});
}


class CreateOffer extends AddOfferEvent{
  String nbHour;
  DateTime dateBegin;
  DateTime dateEnd;
  String price;
  bool isByHour;

  CreateOffer({
    required this.nbHour,
    required this.dateBegin,
    required this.dateEnd,
    required this.price,
    required this.isByHour});
}



