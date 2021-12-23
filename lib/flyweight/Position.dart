import 'package:gobang/flyweight/Chess.dart';

/// [position] 是棋子的位置类
class Position{
  double? _dx;
  double? _dy;
  Chess? _chess;

  Chess get chess => _chess!;

  set chess(Chess value) {
    _chess = value;
  }

  Position(this._dx, this._dy, this._chess);

  double get dx => _dx!;

  set dx(double value) {
    _dx = value;
  }

  get dy => _dy!;

  set dy(value) {
    _dy = value;
  }
}