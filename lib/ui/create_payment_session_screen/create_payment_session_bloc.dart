import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_payment_session_state.dart';

class CreatePaymentSessionBloc extends Cubit<CreatePaymentSessionState> {
  CreatePaymentSessionBloc() : super(InitialCreatePaymentSessionState()) {
    init();
  }

  void init() async {
    emit(LoadingCreatePaymentSessionState());

    await Future.delayed(const Duration(milliseconds: 1200), () {
      emit(LoadedCreatePaymentSessionState());
    });
  }
}
