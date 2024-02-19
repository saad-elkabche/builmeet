import 'package:builmeet/core/dependencies/dependencies.dart';
import 'package:builmeet/domain/repository/repository.dart';
import 'package:builmeet/presentation/ui/components/custom_button.dart';
import 'package:flutter/material.dart';





class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyCustomButton(
        name: 'logout',
        onClick: logout,
      )
    );
  }

  void logout() async{
    Repository repository= Dependencies.get<Repository>();
    await repository.signOut();
  }
}


