import 'package:flutter/material.dart';
import 'map_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
      '/drawer': (context) => Container()
        // todo add screen to show drawer
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // for the drawer icon color change
        primaryIconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          body2: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          body1: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 14),
          display1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          elevation: 16.0,
          margin: EdgeInsets.all(10.0)
        )
      ),
      home: new MapScreen()
    );
  }
}