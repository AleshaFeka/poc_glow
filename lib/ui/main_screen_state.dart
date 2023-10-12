class MainScreenState {}

class WebViewInteractionState extends MainScreenState {}

class CreatePaymentSessionState extends MainScreenState {}

class PaymentSessionState extends WebViewInteractionState {
  final String token;
  final bool isAbleToContinue;
  PaymentSessionState(this.token, {this.isAbleToContinue = false});
}

class ApplicationState extends WebViewInteractionState {}

class FinalState extends MainScreenState {
  final Result result;

  FinalState(this.result);
}

enum Result {
  success, pending, fail
}
