class ApplicationScreenState {}

class ApplicationScreenInitialState extends ApplicationScreenState {}

class ApplicationScreenUrlLoadingState extends ApplicationScreenState {}

class ApplicationScreenNoPermissionsGrantedState extends ApplicationScreenState {}

class ApplicationScreenUrlLoadedState extends ApplicationScreenState {
  final String appUrl;

  ApplicationScreenUrlLoadedState({required this.appUrl});
}

class ApplicationScreenBackButtonPressedState extends ApplicationScreenUrlLoadedState {
  ApplicationScreenBackButtonPressedState({required String appUrl}) : super(appUrl: appUrl);
}
