import 'dart:ui';

import 'package:flutter/scheduler.dart';

typedef OnThemeChanged = void Function(Brightness);

class ThemeChangeNotifier {
  PlatformDispatcher? _platformDispatcher;

  final List<OnThemeChanged> _listeners = List.empty(growable: true);

  ThemeChangeNotifier() {
    _platformDispatcher ??= SchedulerBinding.instance.platformDispatcher;
    _addThemeChangeListener();
  }

  void addListener(OnThemeChanged listener) {
    _listeners.add(listener);
  }

  void removeListener(OnThemeChanged listener) {
    _listeners.remove(listener);
  }

  void _addThemeChangeListener() {
    _platformDispatcher?.onPlatformBrightnessChanged = () {
      var brightness = _platformDispatcher?.platformBrightness;
      if (brightness != null) {
        onPlatformBrightnessChanged(brightness);
      }
    };
  }

  void onPlatformBrightnessChanged(Brightness brightness) {
    for (var listener in _listeners) {
      listener(brightness);
    }
  }
}
