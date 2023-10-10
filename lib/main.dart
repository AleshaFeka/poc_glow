import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_glow/ui/main_screen_provider.dart';

void main() {
  runApp(const MyApp());
}

const primaryColor = Color(0xFF0066FF);
const backgroundColor = Color(0xFFFFFFFF);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
    ));

    return MaterialApp(
      title: 'PoC Glow',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: primaryColor,
          backgroundColor: backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const SafeArea(
        child: MainScreenProvider(),
      ),
    );
  }
}
