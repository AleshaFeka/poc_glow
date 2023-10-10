import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_glow/data/main_screen_state.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  MainScreenBloc() : super(CreatePaymentSessionState());

  void goToCreatePaymentSession() {
    emit(PaymentSessionState());
  }

  void proceedReset() {
    emit(CreatePaymentSessionState());
  }

  void proceedContinue() {

  }
}