import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  StreamSubscription<MainScreenState>? streamSubscription;
  Repository repository;
  HomeBloc({required this.repository}) : super(HomeState.empty()) {

    on<FetchOffers>(_fetchData);
    on<ListeneToMainScreen>(_listenToMainSecreenState);
  }



  FutureOr<void> _listenToMainSecreenState(ListeneToMainScreen event, Emitter<HomeState> emit) {
    event.mainScreenBloc.stream.listen(
     (event) {

    });
  }

  FutureOr<void> _fetchData(FetchOffers event, Emitter<HomeState> emit) async{
    try{
      emit(state.copyWith(fetchDataStatus: AppStatus.loading));
      List<OfferEntity> offers;
      if(event.appMode==UserTypes.client){
        offers=await repository.getOfferForClient();
      }else{
        offers=await repository.getOfferForClient();
      }
      emit(state.copyWith(fetchDataStatus: AppStatus.success,offers: offers));
    }catch(ex){
      emit(state.copyWith(fetchDataStatus: AppStatus.error));
      rethrow;
    }
  }
}
