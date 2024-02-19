import 'package:bloc/bloc.dart';
import 'package:builmeet/core/constants/enums.dart';
import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/core/services/shared_pref_service.dart';


part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());




  void setFirstUseValue(){
    SharedPrefService sharedPrefService= Dependencies.get<SharedPrefService>();
    sharedPrefService.putValue(SharedPrefService.firstUse, false);
    emit(OnboardingState(settingFirstUseStatus: AppStatus.success));
  }







}
