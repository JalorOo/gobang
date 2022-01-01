import 'Memo.dart';

class CareTaker{
  List<Memo> mementoList = [];

  void add(Memo state){
    mementoList.add(state);
    if (mementoList.length>3) {
      mementoList.removeAt(0);
    }
  }

  Memo get(int index){
    return mementoList[index];
  }

  Memo getLast(){
    return mementoList.last;
  }
}