import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:meta/meta.dart';

part 'voir_offer_state.dart';

class VoirOfferCubit extends Cubit<VoirOfferState> {

  Repository repository;



  VoirOfferCubit({required this.repository,required OfferEntity offerEntity})
      : super(VoirOfferState.empty(offerEntity: offerEntity));


  void finishOffer()async{
    try{
      emit(state.copyWith(finishOfferStatus: AppStatus.loading));
      OfferEntity offerEntityRes=await repository.finishOffer(state.offerEntity!);
      emit(state.copyWith(
          finishOfferStatus: AppStatus.success,
          offer: offerEntityRes));
    }catch(ex){
      emit(state.copyWith(finishOfferStatus: AppStatus.error));
      rethrow;
    }
  }

}
