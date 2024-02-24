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