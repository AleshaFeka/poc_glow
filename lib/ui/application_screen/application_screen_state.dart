import 'dart:ui';

class ApplicationScreenState {}

class ApplicationScreenInitialState extends ApplicationScreenState {}

class ApplicationScreenThemeChangedState extends ApplicationScreenState {
  final Brightness brightness;

  ApplicationScreenThemeChangedState(this.brightness) : super();
}

class ApplicationScreenUrlLoadingState extends ApplicationScreenState {}

class ApplicationScreenNoPermissionsGrantedState extends ApplicationScreenState {}

class ApplicationScreenUrlLoadedState extends ApplicationScreenState {
  final String appUrl;

  ApplicationScreenUrlLoadedState({required this.appUrl});
}

class ApplicationScreenBackButtonPressedState extends ApplicationScreenUrlLoadedState {
  ApplicationScreenBackButtonPressedState({required String appUrl}) : super(appUrl: appUrl);
}
