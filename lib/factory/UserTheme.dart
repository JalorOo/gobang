import 'dart:ui';

import 'package:flutter/material.dart';

import 'Theme.dart' as t;

class YellowTheme extends t.Theme{
  @override
  Color getThemeColor() {
    return Colors.amberAccent;
  }
}

class BlueTheme extends t.Theme{
  @override
  Color getThemeColor() {
    return Colors.blue;
  }
}