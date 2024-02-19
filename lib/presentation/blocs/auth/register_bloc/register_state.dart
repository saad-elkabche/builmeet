part of 'register_bloc.dart';

 class RegisterState {

   AppStatus? registerStatus;
   String? error;
   File? profImage;

   RegisterState.empty();

   RegisterState({this.error,this.profImage,this.registerStatus});

   RegisterState copyWith({AppStatus? registerStatus,String? error,File? profImage}){
     return RegisterState(
       error: error,
       profImage: profImage ?? this.profImage,
       registerStatus: registerStatus ?? this.registerStatus
     );
   }

 }

