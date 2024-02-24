part of 'main_screen_bloc.dart';

@immutable
abstract class MainScreenEvent {}


class FetchData extends MainScreenEvent{

}


class NotifyAppModeChanged extends MainScreenEvent{

}