import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/model/loan_options.dart';

import 'main_screen_state.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  MainScreenBloc() : super(CreatePaymentSessionState());

  void goToCreatePaymentSession(String token) {
    emit(PaymentSessionState(token));
  }

  void proceedReset() {
    emit(CreatePaymentSessionState());
  }

  void proceedContinue() {
    emit(ApplicationState());
  }

  void onLoanOptionsConfirmed(LoanOptions options) {
    print("options.payload.upfrontPayment - ${options.payload.upfrontPayment}");
    emit(ApplicationState());
  }

  void onLoanOptionsSelected() {
    if (state is PaymentSessionState) {
      emit(
        PaymentSessionState(
          (state as PaymentSessionState).token,
          isAbleToContinue: true,
        ),
      );
    }
  }
}
