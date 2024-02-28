import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/extenssions/user_types_extenssion.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';
import 'package:builmeet/domain/entities/offer_entity.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:meta/meta.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  Repository repository;
  SharedPrefService sharedPrefService;

  RatingCubit({required this.repository,required this.sharedPrefService,required OfferEntity offerEntity})
      : super(RatingState.empty(offerEntity: offerEntity));


  void setAppMode(){
    String appModeStr;
    if(!sharedPrefService.contains(SharedPrefService.app_mode)){
      sharedPrefService.putValue(SharedPrefService.app_mode, UserTypes.client.getString());
    }
    appModeStr=sharedPrefService.getValue(SharedPrefService.app_mode, UserTypes.client.getString());

    UserTypes appMode=appModeStr.userType;
    emit(state.copyWith(appMode: appMode));

  }


  void rateOffer(int rate)async{
    try{


      print('=================AppMode===========================${state.appMode}');

      emit(state.copyWith(ratingStatus: AppStatus.loading));
      if(state.appMode==UserTypes.client){
        OfferEntity newOffer=state.offerEntity!.copyWith(clientRate: rate);
        print('client rate offer');
        await repository.clientRateOffer(newOffer);
      }else{
        OfferEntity newOffer=state.offerEntity!.copyWith(employeeRate: rate);
        print('employee rate offer');
        await repository.employeeRateOffer(newOffer);
      }
      emit(state.copyWith(ratingStatus: AppStatus.success));
    }catch(ex){
      emit(state.copyWith(ratingStatus: AppStatus.error));

    }
  }


}
