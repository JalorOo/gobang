import 'dart:math';

import 'package:flutter/cupertino.dart';

var baiZiBean;
var heiZiBean;
List<BaiZiBean> baiZiBeanList = []; //所有白子的坐标点集合
List<HeiZiBean> heiZiBeanList = []; //所有黑子的坐标点集合
var flag = true; //默认为白子先走

///简单的实现五子棋效果
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: CupertinoButton.filled(
                  padding: EdgeInsets.all(0.0),
                  child: Text("重置棋盘"),
                  onPressed: () {
                    setState(() {
                      baiZiBean = null;
                      heiZiBean = null;
                      baiZiBeanList.clear();
                      heiZiBeanList.clear();
                    });
                  }),
            ),
            GestureDetector(
                onTapDown: (topDownDetails) {
                  setState(() {
                    var position = topDownDetails.localPosition;
                    if (flag) {
                      baiZiBean = BaiZiBean(position.dx, position.dy);
                    } else {
                      heiZiBean = HeiZiBean(position.dx, position.dy);
                    }
                  });
                },
                child: CustomPaint(
                  size: Size(300.0, 300.0),
                  painter: WuZiQiPainter(),
                ))
          ]),
    );
  }
}

class WuZiQiPainter extends CustomPainter {
  List<CrossOverBean> _crossOverBeanList = [];

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    _crossOverBeanList.clear();
    canvas.drawColor(CupertinoColors.systemGrey, BlendMode.colorBurn);//重绘下整个界面的画布北京颜色
    double mWidth = size.width / 15;
    double mHeight = size.height / 15;
    //设置画笔，画棋盘背景
    var mPaint = Paint()
      ..isAntiAlias = true //抗锯齿
      ..style = PaintingStyle.fill //填充
      ..color = Color(0x77cdb175); //背景为纸黄色
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        mPaint);
    //画棋盘网格
    mPaint
      ..style = PaintingStyle.stroke
      ..color = CupertinoColors.systemGrey6
      ..strokeWidth = 1.0;
    for (var i = 0; i <= 15; i++) {
      //画横线
      canvas.drawLine(
          Offset(0, mHeight * i), Offset(size.width, mHeight * i), mPaint);
    }
    for (var i = 0; i <= 15; i++) {
      //画竖线
      canvas.drawLine(
          Offset(mWidth * i, 0), Offset(mWidth * i, size.height), mPaint);
    }
    //记录横竖线所有的交叉点
    for (int i = 0; i <= 15; i++) {
      for (int j = 0; j <= 15; j++) {
        _crossOverBeanList.add(CrossOverBean(mWidth * j, mHeight * i));
      }
    }
    //求两个点之间的距离,让棋子正确的显示在坐标轴上面
    if(flag && baiZiBean != null){
      //白子棋
      var dx = baiZiBean._dx;
      var dy = baiZiBean._dy;
      for(int i=0; i<_crossOverBeanList.length; i++){
        var absX = (dx - _crossOverBeanList[i]._dx).abs(); //两个点的x轴距离
        var absY = (dy - _crossOverBeanList[i]._dy).abs(); //两个点的y轴距离
        var s = sqrt(absX*absX + absY*absY); //利用直角三角形求斜边公式（a的平方 + b的平方 = c的平方）来计算出两点间的距离
        if(s <= mWidth/2 - 2){ // 触摸点到棋盘坐标坐标点距离小于等于棋子半径，那么
          //找到离触摸点最近的棋盘坐标点并记录保存下来
          baiZiBeanList.add(BaiZiBean(_crossOverBeanList[i]._dx, _crossOverBeanList[i]._dy));
          flag = false; //白子下完了，该黑子下了
          break;
        }
      }
    }else if(heiZiBean != null){
      //黑子棋
      var dx = heiZiBean._dx;
      var dy = heiZiBean._dy;
      for(int i=0; i<_crossOverBeanList.length; i++){
        var absX = (dx - _crossOverBeanList[i]._dx).abs();
        var absY = (dy - _crossOverBeanList[i]._dy).abs();
        var s = sqrt(absX*absX + absY*absY);
        if(s <= mWidth/2 - 2){
          heiZiBeanList.add(HeiZiBean(_crossOverBeanList[i]._dx, _crossOverBeanList[i]._dy));
          flag = true;
          break;
        }
      }
    }

    //画白子
    mPaint
      ..style = PaintingStyle.fill
      ..color = CupertinoColors.white;
    if (baiZiBeanList.isNotEmpty) {
      for (int i = 0; i < baiZiBeanList.length; i++) {
        canvas.drawCircle(Offset(baiZiBeanList[i]._dx, baiZiBeanList[i]._dy),
            min(mWidth / 2, mHeight / 2) - 2, mPaint);
      }
    }
    //画黑子
    mPaint..color = CupertinoColors.black;
    if (heiZiBeanList.isNotEmpty) {
      for (int i = 0; i < heiZiBeanList.length; i++) {
        canvas.drawCircle(Offset(heiZiBeanList[i]._dx, heiZiBeanList[i]._dy),
            min(mWidth / 2, mHeight / 2) - 2, mPaint);
      }
    }
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class BaiZiBean {
  double _dx;
  double _dy;

  BaiZiBean(this._dx, this._dy);
}

class HeiZiBean {
  double _dx;
  double _dy;

  HeiZiBean(this._dx, this._dy);
}

///记录棋盘上横竖线的交叉点
class CrossOverBean {
  double _dx;
  double _dy;

  CrossOverBean(this._dx, this._dy);
}