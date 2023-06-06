
import 'package:flutter/material.dart';

import 'Screens/blutooth_screen.dart';
import 'Screens/profile_screen.dart';
import 'Screens/random_image_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      title: "finiinfcom",
      // routes: AppPages.routes,
      // initialRoute: AppRoutes.initial,
      home:RandomImageScreen()
    );
  }
}

