import 'package:poc_glow/data/model/result.dart';

import '../data/model/loan_options.dart';

class MainScreenState {}

class WebViewInteractionState extends MainScreenState {}

class CreatePaymentSessionState extends MainScreenState {}

class PaymentSessionState extends WebViewInteractionState {
  final String token;
  final bool isAbleToContinue;
  PaymentSessionState(this.token, {required this.isAbleToContinue});
}

class ApplicationState extends WebViewInteractionState {
  final LoanOptions options;

  ApplicationState(this.options);
}

class FinalState extends MainScreenState {
  final Result result;

  FinalState(this.result);
}