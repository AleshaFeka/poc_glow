class CreatePaymentSessionState {}

class InitialCreatePaymentSessionState  extends CreatePaymentSessionState{}

class LoadingCreatePaymentSessionState  extends CreatePaymentSessionState{}

class LoadedCreatePaymentSessionState  extends CreatePaymentSessionState {
  final String token;

  LoadedCreatePaymentSessionState(this.token);
}

class ErrorCreatePaymentSessionState  extends CreatePaymentSessionState{}
