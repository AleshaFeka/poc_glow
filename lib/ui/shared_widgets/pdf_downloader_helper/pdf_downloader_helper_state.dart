abstract class PdfDownloadingState {}

class PdfDownloadingInitialState extends PdfDownloadingState {}

class CheckingStoragePermissionState extends PdfDownloadingState {}

class StoragePermissionDeniedStateState extends PdfDownloadingState {}

class PdfLoadInProgressState extends PdfDownloadingState {}

class PdfLoadFailedState extends PdfDownloadingState {}

class PdfLoadSuccessState extends PdfDownloadingState {}