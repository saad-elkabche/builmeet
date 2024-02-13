import 'package:builmeet/presentation/ui/secreens/secreens.dart';
import 'package:go_router/go_router.dart';




class Routes{

  static const String login='/login';
  static const String register='/register';

  static GoRouter router=GoRouter(
      routes: [

        GoRoute(
            path: login,
          pageBuilder: (context,state)=>NoTransitionPage(child: LoginSecren.page())
        )


      ]
  );

}