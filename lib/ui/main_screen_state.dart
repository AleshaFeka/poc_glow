import 'dart:ui';

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

enum Result {
  success, pending, fail

}

extension ResultExt on Result {
  Color getBackgroundColor() {
    switch (this) {

      case Result.success:
        return Color(0xFFF1FAE5);
      case Result.pending:
        return Color(0xFFFAF4E5);
      case Result.fail:
        return Color(0xFFFAE5E9);
    }
  }

  String getText() {
    switch (this) {
      case Result.success:
        return "Success";
      case Result.pending:
        return "Pending";
      case Result.fail:
        return "Fail";
    }
  }

  String getIcon() {
    switch (this) {

      case Result.success:
        return "assets/images/ic_success.png";
      case Result.pending:
        return "assets/images/ic_pending.png";
      case Result.fail:
        return "assets/images/ic_error.png";
    }
  }
}
