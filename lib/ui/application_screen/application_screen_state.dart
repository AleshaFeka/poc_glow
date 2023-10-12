class ApplicationScreenState {}

class ApplicationScreenInitialState extends ApplicationScreenState {}

class ApplicationScreenUrlLoadingState extends ApplicationScreenState {}

class ApplicationScreenUrlLoadedState extends ApplicationScreenState {
  final String appUrl;

  ApplicationScreenUrlLoadedState({required this.appUrl});
}
