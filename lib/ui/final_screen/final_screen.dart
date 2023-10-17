import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_glow/data/model/result.dart';

class FinalScreen extends StatelessWidget {
  final Result result;

  const FinalScreen(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: result.getBackgroundColor(),
      ),
    );

    return Expanded(
      child: Container(
        color: result.getBackgroundColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (result.getIcon().isNotEmpty) Image.asset(result.getIcon()),
              Text(
                result.getText(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
