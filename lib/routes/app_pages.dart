import 'package:fininfocom/Screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import '../Screens/blutooth_screen.dart';
import '../Screens/random_image_screen.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.randomImageScreen: (context) => RandomImageScreen(),
      AppRoutes.blutoothSCtreen: (context) => BlutoothScreen(),
      AppRoutes.profileScreen: (context) => ProfileScreen(),
     
    };
  }
}
