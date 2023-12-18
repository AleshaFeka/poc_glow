import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/model/loan_options.dart';
import 'package:poc_glow/data/model/result.dart';
import 'package:poc_glow/util/theme_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_state.dart';

const _prefDarkThemeKey = "themeColor";
const _prefEnvUrlKey = "envUrl";
const _prefFirstNameKey = "firstName";
const _prefLastNameKey = "lastName";
const _prefBasketValueKey = "basketValue";

const _envUrlDefaultValue = "platform-api.dev03.glowfinsvs.com";
const _firstNameDefaultValue = "John";
const _lastNameDefaultValue = "Smith";
const _basketValueDefaultValue = "1900";

class MainScreenBloc extends Cubit<MainScreenState> {
  LoanOptions? _options;
  ThemeChangeNotifier themeChangeNotifier;
  SharedPreferences? _prefs;

/*
  String customerFirstName = _firstNameDefaultValue;
  String customerLastName = _lastNameDefaultValue;
  int basketValue = _basketValueDefaultValue;
*/

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


  set customerFirstName(String newValue) {
    print("customerFirstName - $newValue");
    _prefs?.setString(_prefFirstNameKey, newValue);
  }

  String get customerFirstName {
    print("get customerFirstName - ${_prefs?.getString(_prefFirstNameKey)}");
    return _prefs?.getString(_prefFirstNameKey) ?? _firstNameDefaultValue;
  }

  set customerLastName(String newValue) {
    _prefs?.setString(_prefLastNameKey, newValue);
  }

  String get customerLastName {
    return _prefs?.getString(_prefLastNameKey) ?? _lastNameDefaultValue;
  }

  set basketValue(String newValue) {
    _prefs?.setString(_prefBasketValueKey, newValue);
  }

  String get basketValue {
    return _prefs?.getString(_prefBasketValueKey) ?? _basketValueDefaultValue;
  }

  set envUrl(String newValue) {
    _prefs?.setString(_prefEnvUrlKey, newValue);
  }

  String get envUrl {
    return _prefs?.getString(_prefEnvUrlKey) ?? _envUrlDefaultValue;
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
