import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gobang/bridge/ChessShape.dart';

/// 棋子的抽象类
/// 使用了桥接模式，外观和颜色是两个不同的维度
abstract class Chess{

  Color? _color;

  Color get color => _color!;

  ChessShape? _chessShape;

  ChessShape get chessShape => _chessShape!;

  set chessShape(ChessShape? __chessShape);
}

class BlackChess extends Chess{
  BlackChess() {
    _color = Colors.black;
  }

  set chessShape(ChessShape? __chessShape) {
    super._chessShape = __chessShape;
  }
}

class WhiteChess extends Chess{
  WhiteChess() {
    _color = Colors.white;
  }

  set chessShape(ChessShape? __chessShape) {
    super._chessShape = __chessShape;
  }
}