import 'dart:ui';

import '../../data/model/loan_options.dart';

class PaymentSessionState {}

class PaymentSessionUrlLoadingState extends PaymentSessionState {}

class PaymentSessionUrlReadyState extends PaymentSessionState {
  final String loanUrl;

  PaymentSessionUrlReadyState(this.loanUrl);
}

class PaymentSessionUrlLoadedState extends PaymentSessionUrlReadyState {
  PaymentSessionUrlLoadedState(String loanUrl) : super(loanUrl);
}

class PaymentSessionLoanOptionsSelectedState extends PaymentSessionUrlReadyState {
  final LoanOptions options;

  PaymentSessionLoanOptionsSelectedState(String loanUrl, this.options) : super(loanUrl);
}

class PaymentSessionThemeChangedState extends PaymentSessionState {
  final Brightness brightness;

  PaymentSessionThemeChangedState(this.brightness) : super();
}
