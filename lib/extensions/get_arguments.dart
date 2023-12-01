import 'package:flutter/material.dart';

extension GetArguments on BuildContext {
  T? getArguments<T>() {
    final modulroute = ModalRoute.of(this);
    if (modulroute != null) {
      final args = modulroute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
