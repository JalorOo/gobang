import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/Position.dart';
import 'package:gobang/memorandum/CareTaker.dart';

import 'Memo.dart';

class Checkerboard {

  Checkerboard._();

  static Checkerboard? _originator;

  static getInstance(){
    if(_originator == null){
      _originator = Checkerboard._();
    }
    return _originator;
  }

  bool _canAdd = true; //是否需要添加

  List<Position> _state = [];

  List<Position> get state{
    return _state;
  }

  CareTaker _careTaker = CareTaker();

  add(Position position) {
    if(_canAdd) { //因为每次渲染完默认会把最后一个下棋的位置添加上，但在悔棋阶段最后一个是不需要，因此需要这个判断。
      _state.add(position);
      _careTaker.add(_save());
    }
    _canAdd = true;
  }

  _from(Memo memo) {
    this._state = memo.state;
  }

  Memo _save() {
    return new Memo()..state.addAll(this._state);
  }

  clean(){
    _state = [];
  }

  undo() {
    Memo memo = _careTaker.getLast();
    _from(memo);
    _canAdd = false;
  }


}