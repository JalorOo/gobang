import 'package:gobang/state/UserContext.dart';

abstract class State {
  int _step = 0;
  int _rect = 0;
  UserContext _userContext;

  State(UserContext userContext):_userContext = userContext;

  // 悔棋只能悔棋三次
  bool regretChess();

  // 认输10步之内不能认输
  bool surrender();

  play() {
    _step++;
  }

}

/// [StartState] 开始状态
class StartState extends State {

  StartState(UserContext userContext) : super(userContext);



  // 悔棋只能悔棋三次
  @override
  bool regretChess(){
    return false;
  }

  @override
  bool surrender() {
    return false;
  }

  @override
  play() {
    super.play();
    if(_step >= 10) {
      _userContext.setState(MidState(_userContext).._step = _step.._rect = _rect);
    }
  }

}

/// [MidState] 中场状态
class MidState extends State {
  MidState(UserContext userContext) : super(userContext);

  // 悔棋只能悔棋三次
  @override
  bool regretChess(){
    if(_rect > 3) {
      _userContext.setState(EndState(_userContext).._step = _step.._rect = _rect);
      return false;
    }
    return true;
  }

  @override
  bool surrender() {
    return true;
  }

}

/// [EndState] 结尾状态
class EndState extends State {
  EndState(UserContext userContext) : super(userContext);



  // 悔棋只能悔棋三次
  @override
  regretChess(){
    return false;
  }

  @override
  surrender() {
    return true;
  }

}