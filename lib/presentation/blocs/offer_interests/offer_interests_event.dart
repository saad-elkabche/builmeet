part of 'offer_interests_bloc.dart';

@immutable
abstract class OfferInterestsEvent {}


class FetchInterests extends OfferInterestsEvent{

}

class AcceptInterest extends OfferInterestsEvent{
  InterestEntity interestEntity;

  AcceptInterest(this.interestEntity);
}

class RefuseInterest extends OfferInterestsEvent{
  InterestEntity interestEntity;

  RefuseInterest(this.interestEntity);
}

