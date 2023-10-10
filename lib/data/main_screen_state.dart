class MainScreenState {}

class WebViewInteractionState extends MainScreenState {}

class CreatePaymentSessionState extends MainScreenState {}

class PaymentSessionState extends WebViewInteractionState {}

class ApplicationState extends WebViewInteractionState {}

class FinalState extends MainScreenState {
  final Result result;

  FinalState(this.result);
}

enum Result {
  success, pending, fail
}
