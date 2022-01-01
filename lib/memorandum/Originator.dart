import 'package:gobang/flyweight/Position.dart';
import 'package:gobang/memorandum/CareTaker.dart';

import 'Memo.dart';

class Originator {

  Originator._();

  static Originator? _originator;

  static getInstance(){
    if(_originator == null){
      _originator = Originator._();
    }
    return _originator;
  }

  List<Position> _state = [];

  List<Position> get state => _state;

  CareTaker _careTaker = CareTaker();

  add(Position position) {
    _state.add(position);
    _careTaker.add(_save());
  }

  _from(Memo memo) {
    this._state = memo.state;
  }

  Memo _save() {
    return Memo()..state = this._state;
  }

  clean(){
    _state = [];
  }

  undo(){
    Memo memo = _careTaker.getLast();
    _from(memo);
  }
}