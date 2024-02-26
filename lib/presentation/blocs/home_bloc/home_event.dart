part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}


class FetchOffers extends HomeEvent{
  FetchOffers();
}


class ListeneToMainScreen extends HomeEvent{
  MainScreenBloc mainScreenBloc;

  ListeneToMainScreen(this.mainScreenBloc);
}



class EmployeeInteresser extends HomeEvent{
  OfferEntity offerEntity;
  double? price;

  EmployeeInteresser({required this.offerEntity, this.price});
}

class EmployeeNotIntersted extends HomeEvent{
  OfferEntity offerEntity;
  int index;
  EmployeeNotIntersted({required this.offerEntity,required this.index});
}
