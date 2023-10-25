import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/model/loan_options.dart';
import 'package:poc_glow/data/model/result.dart';
import 'package:poc_glow/util/theme_change_notifier.dart';

import 'main_screen_state.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  LoanOptions? _options;
  ThemeChangeNotifier themeChangeNotifier;

  MainScreenBloc()
      : themeChangeNotifier = ThemeChangeNotifier(),
        super(CreatePaymentSessionState());

  void goToCreatePaymentSession(String token) {
    emit(PaymentSessionState(
      token,
      isAbleToContinue: false,
    ));
  }

  void proceedReset() {
    emit(CreatePaymentSessionState());
  }

  void proceedContinue() {
    if (_options != null) {
      emit(ApplicationState(_options!));
    }
  }

  void onLoanOptionsSelected(LoanOptions options) {
    _options = options;
    if (state is PaymentSessionState) {
      emit(
        PaymentSessionState(
          (state as PaymentSessionState).token,
          isAbleToContinue: true,
        ),
      );
    }
  }

  void onApplicationScreenDone(Result result) {
    emit(FinalState(result));
  }
}
