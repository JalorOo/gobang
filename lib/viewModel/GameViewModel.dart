import 'package:gobang/bridge/ChessShape.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/ChessFlyweightFactory.dart';
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

  Chess play() {
    _userContext.play();
    Chess chess;
    /// 设置棋子外观
    ChessShape shape = RectShape();
    chess = ChessFlyweightFactory.getInstance().getChess("white");
    chess.chessShape = shape;
    return chess;
  }

  bool undo() {
    return _userContext.regretChess();
  }


}
