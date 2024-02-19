



import 'package:builmeet/domain/entities/user_entity.dart';

abstract class Repository{


  Future<void> register(UserEntity userEntity);
  Future<UserEntity> login(UserEntity userEntity);
  Future<UserEntity> getCurrentUser();
  Future<void> signOut();


}