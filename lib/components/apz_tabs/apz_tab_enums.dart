import 'package:flutter/material.dart';


enum SelectionMode {
  enabled,
  disabled,
}

extension SelectionModeExtension on SelectionMode {
  bool get value => this == SelectionMode.enabled;

  static SelectionMode fromBool(bool val) {
    return val ? SelectionMode.enabled : SelectionMode.disabled;
  }

  static SelectionMode? fromDynamic(dynamic val) {
    if (val is bool) return fromBool(val);
    if (val is String) {
      switch (val.toLowerCase()) {
        case 'true':
        case 'enabled':
          return SelectionMode.enabled;
        case 'false':
        case 'disabled':
          return SelectionMode.disabled;
      }
    }
    return null;
  }
}


enum TabBarDirection {
  horizontal,
  vertical,
}

extension TabBarDirectionExtension on TabBarDirection {
  Axis get axis =>
      this == TabBarDirection.horizontal ? Axis.horizontal : Axis.vertical;

  static TabBarDirection fromString(String val) {
    return val.toLowerCase() == 'vertical'
        ? TabBarDirection.vertical
        : TabBarDirection.horizontal;
  }

  static TabBarDirection? fromDynamic(dynamic val) {
    if (val is String) {
      return fromString(val);
    }
    return null;
  }

  String get name => this == TabBarDirection.vertical ? 'vertical' : 'horizontal';
}
