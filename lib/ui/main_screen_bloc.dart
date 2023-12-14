import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/model/loan_options.dart';
import 'package:poc_glow/data/model/result.dart';
import 'package:poc_glow/util/theme_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_state.dart';

const _prefDarkThemeKey = "themeColor";

class MainScreenBloc extends Cubit<MainScreenState> {
  LoanOptions? _options;
  ThemeChangeNotifier themeChangeNotifier;
  SharedPreferences? _prefs;

  MainScreenBloc()
      : themeChangeNotifier = ThemeChangeNotifier(),
        super(CreatePaymentSessionState()) {
    initPrefs();
  }

  set darkTheme(bool newValue) {
    _prefs?.setBool(_prefDarkThemeKey, newValue);
  }

  bool get isDarkTheme {
    return _prefs?.getBool(_prefDarkThemeKey) ?? false;
  }

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

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
