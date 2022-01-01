import 'package:gobang/flyweight/Position.dart';

class Memo {
  List<Position> _state = [];

  List<Position> get state => _state;

  set state(List<Position> value) {
    _state = value;
  }
}