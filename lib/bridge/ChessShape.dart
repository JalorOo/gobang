abstract class ChessShape{
  int? _shape;

  int get shape => _shape!;
}

class CircleShape extends ChessShape{
  CircleShape(){
    _shape = 1;
  }
}

class RectShape extends ChessShape{
  RectShape(){
    _shape = 2;
  }
}