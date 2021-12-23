import 'dart:ui';

import 'package:flutter/material.dart';

/// 棋子的抽象类
abstract class Chess{

  Color? _color;

  Color get color => _color!;
}

class BlackChess extends Chess{
  BlackChess() {
    _color = Colors.black;
  }
}

class WhiteChess extends Chess{
  WhiteChess() {
    _color = Colors.white;
  }
}