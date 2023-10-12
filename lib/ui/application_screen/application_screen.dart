import 'package:flutter/material.dart';
import 'package:poc_glow/data/model/loan_options.dart';

class ApplicationScreen extends StatelessWidget {
  final LoanOptions options;
  const ApplicationScreen(this.options, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          color: Colors.yellow,
          child: Text(options.payload.interestRate.toString()),
        ),
      ),
    );
  }
}
