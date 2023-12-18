import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/model/loan_options.dart';
import 'package:poc_glow/data/model/result.dart';
import 'package:poc_glow/data/shared_prefs_provider.dart';
import 'package:poc_glow/data/url_provider.dart';
import 'package:poc_glow/util/theme_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_state.dart';

const _prefDarkThemeKey = "themeColor";
const _prefFirstNameKey = "firstName";
const _prefLastNameKey = "lastName";
const _prefBasketValueKey = "basketValue";

const _firstNameDefaultValue = "John";
const _lastNameDefaultValue = "Smith";
const _basketValueDefaultValue = "1900";

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


  set customerFirstName(String newValue) {
    _prefs?.setString(_prefFirstNameKey, newValue);
  }

  String get customerFirstName {
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
    EeUrlProvider.setNewEnvUrl(newValue);
  }

  String get envUrl {
    return EeUrlProvider.getCurrentEnvUrl();
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
    _prefs ??= await SharedPreferencesProvider.initAndGetInstance();
    EeUrlProvider.init();
    emit(CreatePaymentSessionState());
  }
}
