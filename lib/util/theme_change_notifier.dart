import 'dart:ui';

import 'package:flutter/scheduler.dart';

typedef ThemeChangedListener = void Function(Brightness);

class ThemeChangeNotifier {
  PlatformDispatcher? _platformDispatcher;

  ThemeChangedListener _singleListener = (_) {};

  ThemeChangeNotifier() {
    _platformDispatcher ??= SchedulerBinding.instance.platformDispatcher;
    _addThemeChangeInternalListener();
  }

  Brightness getCurrentSystemBrightness() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void setSingleListener(ThemeChangedListener listener) {
    _singleListener = listener;
  }

  void _addThemeChangeInternalListener() {
    _platformDispatcher?.onPlatformBrightnessChanged = () {
      var brightness = _platformDispatcher?.platformBrightness;
      if (brightness != null) {
        _onPlatformBrightnessChanged(brightness);
      }
    };
  }

  void _onPlatformBrightnessChanged(Brightness brightness) {
    _singleListener(brightness);
  }
}
