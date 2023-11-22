class CreatePaymentSessionState {}

class InitialCreatePaymentSessionState  extends CreatePaymentSessionState{}

class LoadingCreatePaymentSessionState  extends CreatePaymentSessionState{}

class LoadedCreatePaymentSessionState  extends CreatePaymentSessionState {
  final String token;

  LoadedCreatePaymentSessionState(this.token);
}

class ErrorCreatePaymentSessionState  extends CreatePaymentSessionState{}


abstract class PdfProcessingState extends CreatePaymentSessionState {}

class CheckingStoragePermissionState extends PdfProcessingState {}

class StoragePermissionDeniedStateState extends PdfProcessingState {}

class PdfLoadInProgressState extends PdfProcessingState {}

class PdfLoadFailedState extends PdfProcessingState {}

class PdfLoadSuccessState extends PdfProcessingState {}

