import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:polaroid/screens/SignUP.dart';
import 'package:polaroid/widgets/Navigation.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/BottomNavigator':(context)=>Navigation(),
      },
      home:AuthScreen() ,
    );
  }
}


