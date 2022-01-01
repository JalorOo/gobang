import 'package:gobang/state/State.dart';

class UserContext {

  late State _state;

  State get state => _state;

  UserContext(){
    _state = StartState(this);
  }

  play() {
    _state.play();
  }

  // 悔棋只能悔棋三次
  bool regretChess() {
    return _state.regretChess();
  }

  // 认输10步之内不能认输
  bool surrender() {
    return _state.surrender();
  }

  setState(State state){
    _state = state;
  }

  void reset() {
    _state = StartState(this);
  }
}