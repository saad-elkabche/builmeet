part of 'journal_bloc.dart';

@immutable
abstract class JournalEvent {}


class FetchData extends JournalEvent{

}

class ListeneToMainSecreenBloc extends JournalEvent{
  MainScreenBloc mainScreenBloc;

  ListeneToMainSecreenBloc(this.mainScreenBloc);
}


class ClientFinishOffer extends JournalEvent{
  OfferEntity offerEntity;

  ClientFinishOffer(this.offerEntity);
}

class ClientVoirOffer extends JournalEvent{
  OfferEntity offerEntity;

  ClientVoirOffer(this.offerEntity);
}




