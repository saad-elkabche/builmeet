part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}


class FetchOffers extends HomeEvent{
  UserTypes appMode;

  FetchOffers(this.appMode);
}


class ListeneToMainScreen extends HomeEvent{
  MainScreenBloc mainScreenBloc;

  ListeneToMainScreen(this.mainScreenBloc);
}