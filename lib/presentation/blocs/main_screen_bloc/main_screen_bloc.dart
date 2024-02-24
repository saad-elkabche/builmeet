import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/user_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {


  late StreamSubscription<User?> streamAuthSubscription;
  late StreamSubscription<User?> streamAuthSubscription1;


  MainScreenBloc({required FirebaseAuth firebaseAuth}) : super(IntialState()) {


    on<NotifyAppModeChanged>(_notifyAppModeChanged);



    streamAuthSubscription =firebaseAuth.authStateChanges().listen(
      (user) {
        if(user==null){
          emit(UserLogout());
        }
    });

    streamAuthSubscription1 =firebaseAuth.idTokenChanges().listen(
            (user) {
          if(user==null){
            emit(UserLogout());
          }
        }
      );



  }







  @override
  Future<void> close() {
    streamAuthSubscription.cancel();
    streamAuthSubscription1.cancel();
    return super.close();
  }



  FutureOr<void> _notifyAppModeChanged(NotifyAppModeChanged event, Emitter<MainScreenState> emit) {
    emit(AppModeChanged());
  }
}
