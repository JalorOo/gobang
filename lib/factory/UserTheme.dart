import 'dart:ui';

import 'package:flutter/material.dart';

import 'Theme.dart' as t;

class UserTheme extends t.Theme{
  @override
  Color getThemeColor() {
    return Colors.yellow;
  }
}

class AiTheme extends t.Theme{
  @override
  Color getThemeColor() {
    return Colors.blue;
  }
}