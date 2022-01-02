import 'package:flutter/material.dart';
import 'package:gobang/bridge/ChessShape.dart';
import 'package:gobang/bridge/CircleShape.dart';
import 'package:gobang/bridge/RectShape.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/ChessFlyweightFactory.dart';
import 'package:gobang/state/State.dart';
import 'package:gobang/state/UserContext.dart';

class GameViewModel {
  GameViewModel._();

  static GameViewModel? _gameViewModel;

  static getInstance() {
    if (_gameViewModel == null) {
      _gameViewModel = GameViewModel._();
    }
    return _gameViewModel;
  }

  UserContext _userContext = UserContext();

  Chess play(bool current) {
    _userContext.play();
    Chess chess;
    /// 设置棋子外观
    ChessShape shape = RectShape();
    if(current){
      shape = CircleShape();
    }
    chess = ChessFlyweightFactory.getInstance().getChess("white");
    chess.chessShape = shape;
    return chess;
  }

  bool undo() {
    return _userContext.regretChess();
  }

  get state{
    if(_userContext.state is StartState){
      return "热身阶段,不能悔棋，不能投降";
    } else if(_userContext.state is MidState) {
      return "入神阶段,可以悔棋且剩余${3 - _userContext.state.reg}次，可以投降";
    } else if(_userContext.state is EndState) {
      return "白热化阶段,悔棋次数已用完，但可以投降";
    }
  }

  void reset() {
    _userContext.reset();
  }

  bool surrender() {
    return _userContext.surrender();
  }
}
