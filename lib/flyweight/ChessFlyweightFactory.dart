import 'dart:collection';
import 'package:gobang/flyweight/Chess.dart';

/// 棋子的享元工厂，采用单例模式
class ChessFlyweightFactory {
  ChessFlyweightFactory._();

  static ChessFlyweightFactory? _factory;

  static ChessFlyweightFactory getInstance() {
    if (_factory == null) {
      _factory = ChessFlyweightFactory._();
    }
    return _factory!;
  }

  HashMap<String, Chess> _hashMap = HashMap<String, Chess>();

  Chess getChess(String type) {
    Chess chess;
    if (_hashMap[type] != null) {
      chess = _hashMap[type]!;
    } else {
      if (type == "white") {
        chess = WhiteChess();
      } else {
        chess = BlackChess();
      }
      _hashMap[type] = chess;
    }
    return chess;
  }
}
