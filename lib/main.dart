import 'package:flutter/material.dart';
import 'package:where2go/splashScreen.dart';

import 'WhereToGoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Splashscreen.routeName,
routes: {
  Splashscreen.routeName:(context)=>Splashscreen(),
  WhereToGoScreen.routeName:(context)=>WhereToGoScreen(),
},
    );
  }
}
