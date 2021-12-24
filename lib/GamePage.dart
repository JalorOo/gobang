import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gobang/ai/Ai.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/ChessFlyweightFactory.dart';
import 'package:gobang/utils/TipsDialog.dart';

import 'flyweight/Position.dart';

///简单的实现五子棋效果
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("南瓜五子棋"),
      ),
      body: Center(
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
                        ChessPainter._position = null;
                        ChessPainter._positions = [];
                        Ai.getInstance().init();
                        // blackChess = null;
                      });
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: CupertinoButton.filled(
                    padding: EdgeInsets.all(0.0),
                    child: Text("Ai下棋"),
                    onPressed: () {
                        turnAi();
                        // blackChess = null;
                    }),
              ),
              GestureDetector(
                  onTapDown: (topDownDetails) {
                    var position = topDownDetails.localPosition;
                    Chess chess;
                    if (ChessPainter._state == 0) {
                      chess =
                          ChessFlyweightFactory.getInstance().getChess("white");
                    } else {
                      chess =
                          ChessFlyweightFactory.getInstance().getChess("black");
                    }
                    setState(() {
                      ChessPainter._position = Position(position.dx, position.dy, chess);
                    });
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(300.0, 300.0),
                        painter: CheckerBoardPainter(),
                      ),
                      CustomPaint(
                        size: Size(300.0, 300.0),
                        painter: ChessPainter(turnAi),
                      )
                    ],
                  ))
            ]),
      ),
    );
  }

  void turnAi() {
    if(ChessPainter._position!.chess is WhiteChess && Ai.getInstance().isWin(ChessPainter._position!.dx~/(300/15), ChessPainter._position!.dy~/(300/15), 1)){
      TipsDialog.show(context, "恭喜", "您打败了决策树算法");
    }
    Ai ai = Ai.getInstance();
    print("Owner:"+Ai.getInstance().isWin(ChessPainter._position!.dx~/(300/15), ChessPainter._position!.dy~/(300/15), 1).toString());
    ChessPainter._position = ai.searchPosition();
    Ai.getInstance().addChessman(ChessPainter._position!.dx.toInt(), ChessPainter._position!.dy.toInt(), -1);
    print("Ai:"+Ai.getInstance().isWin(ChessPainter._position!.dx.toInt(), ChessPainter._position!.dy.toInt(), -1).toString());
    if(ChessPainter._position!.chess is BlackChess &&Ai.getInstance().isWin(ChessPainter._position!.dx.toInt(), ChessPainter._position!.dy.toInt(), -1)){
      TipsDialog.show(context, "很遗憾", "决策树算法打败了您");
    }
    setState(() {
      ChessPainter._position!.dx = ChessPainter._position!.dx*(300/15);
      ChessPainter._position!.dy = ChessPainter._position!.dy*(300/15);
    });
  }
}

class ChessPainter extends CustomPainter {
  static List<Position> _positions = [];
  static int _state = 0;
  static Position? _position;
  final Function _function;

  ChessPainter(Function f):_function = f;

  @override
  void paint(Canvas canvas, Size size) {
    if (_position == null) {
      return;
    }
    bool add = false;
    double mWidth = size.width / 15;
    double mHeight = size.height / 15;
    var mPaint = Paint();
    //求两个点之间的距离,让棋子正确的显示在坐标轴上面
    var dx = _position!.dx;
    var dy = _position!.dy;
    for (int i = 0; i < CheckerBoardPainter._crossOverBeanList.length; i++) {
      var absX = (dx - CheckerBoardPainter._crossOverBeanList[i]._dx).abs(); //两个点的x轴距离
      var absY = (dy - CheckerBoardPainter._crossOverBeanList[i]._dy).abs(); //两个点的y轴距离
      var s = sqrt(absX * absX +
          absY * absY); //利用直角三角形求斜边公式（a的平方 + b的平方 = c的平方）来计算出两点间的距离
      if (s <= mWidth / 2 - 2) {
        // 触摸点到棋盘坐标坐标点距离小于等于棋子半径，那么
        //找到离触摸点最近的棋盘坐标点并记录保存下来
        _position!.dx = CheckerBoardPainter._crossOverBeanList[i]._dx;
        _position!.dy = CheckerBoardPainter._crossOverBeanList[i]._dy;
        _positions.add(_position!);
        add = true;
        if (_position!.chess is WhiteChess) {
          Ai.getInstance().addChessman(_position!.dx~/(300/15), _position!.dy~/(300/15), 1);
        }
        // flag = false; //白子下完了，该黑子下了
        break;
      }
    }

    //画子
    mPaint..style = PaintingStyle.fill;
    if (_positions.isNotEmpty) {
      for (int i = 0; i < _positions.length; i++) {
        mPaint..color = _positions[i].chess.color;
        canvas.drawCircle(Offset(_positions[i].dx, _positions[i].dy),
            min(mWidth / 2, mHeight / 2) - 2, mPaint);
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (add &&_position!.chess is WhiteChess) {
        _function();
      }
    });
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class CheckerBoardPainter extends CustomPainter {
  static List<CrossOverBean> _crossOverBeanList = [];
  static int _state = 0;

  @override
  void paint(Canvas canvas, Size size) {
    double mWidth = size.width / 15;
    double mHeight = size.height / 15;
    var mPaint = Paint();

    _crossOverBeanList.clear();
    canvas.drawColor(
        CupertinoColors.systemGrey, BlendMode.colorBurn); //重绘下整个界面的画布北京颜色
    //设置画笔，画棋盘背景
    mPaint
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
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

///记录棋盘上横竖线的交叉点
class CrossOverBean {
  double _dx;
  double _dy;

  CrossOverBean(this._dx, this._dy);
}
