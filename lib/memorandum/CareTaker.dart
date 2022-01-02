import 'Memo.dart';

class CareTaker{
  List<Memo> mementoList = [];

  void add(Memo memo) {
    mementoList.add(memo);
    if (mementoList.length > 10) {
      mementoList.removeRange(0, 1);
    }
  }

  Memo get(int index){
    return mementoList[index];
  }

  Memo getLast() {
    Memo memo = mementoList[mementoList.length-3];
    mementoList.removeLast();
    mementoList.removeLast();
    return memo;
  }
}