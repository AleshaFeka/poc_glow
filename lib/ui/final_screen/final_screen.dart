import 'package:flutter/material.dart';
import 'package:poc_glow/ui/main_screen_state.dart';

class FinalScreen extends StatelessWidget {
  final Result result;

  const FinalScreen(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: result.getBackgroundColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(result.getIcon()),
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
