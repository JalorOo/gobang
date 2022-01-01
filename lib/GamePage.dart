import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gobang/ai/Ai.dart';
import 'package:gobang/bridge/ChessShape.dart';
import 'package:gobang/factory/ThemeFactory.dart';
import 'package:gobang/factory/UserTheme.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/ChessFlyweightFactory.dart';
import 'package:gobang/memorandum/Originator.dart';
import 'package:gobang/state/UserContext.dart';
import 'package:gobang/utils/TipsDialog.dart';
import 'package:gobang/viewModel/GameViewModel.dart';

import 'flyweight/Position.dart';

var width = 0.0;

///简单的实现五子棋效果
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  ThemeFactory? _themeFactory;
  GameViewModel _viewModel = GameViewModel.getInstance();
  Originator _originator = Originator.getInstance();
  Icon lightOn = Icon(Icons.lightbulb,color: Colors.amberAccent);
  Icon lightOff = Icon(Icons.lightbulb_outline_rounded);
  Icon circle = Icon(Icons.circle_outlined);
  Icon rect = Icon(Icons.crop_square);
  Icon? currentLight,currentShape;

  @override
  void initState() {
    currentLight = lightOn;
    _themeFactory = BlueThemeFactory();
    currentShape = circle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _themeFactory!.getTheme().getThemeColor(),
        title: Text("南瓜五子棋"),
        actions: [
          IconButton(
              onPressed: () {
                if (_viewModel.undo()) {
                  _originator.undo();
                  Ai.getInstance().init();
                  for (Position po in _originator.state) {
                    Ai.getInstance().addChessman(po.dx ~/ (width / 15),
                        po.dy ~/ (width / 15), po.chess is WhiteChess ? 1 : -1);
                  }
                  setState(() {});
                } else {
                  TipsDialog.show(context, "提示", "现阶段不能悔棋");
                }
              },
              icon: Icon(Icons.undo)),
          IconButton(
              onPressed: () {
                if(_viewModel.surrender()) {
                  TipsDialog.showByChoose(
                      context, "提示", "是否要投降并重新开局？", "是", "否", (value) {
                    if (value) {
                      setState(() {
                        ChessPainter._position = null;
                        _originator.clean();
                        _viewModel.reset();
                        Ai.getInstance().init();
                      });
                    }
                    Navigator.pop(context);
                  });
                }else{
                  TipsDialog.show(context, "提示", "现阶段不能投降");
                }
              },
              icon: Icon(Icons.sports_handball)),
          IconButton(
              onPressed: () {
                TipsDialog.showByChoose(context, "提示", "是否重新开局？","是","否",(value){
                  if(value){
                    setState(() {
                      ChessPainter._position = null;
                      _originator.clean();
                      _viewModel.reset();
                      Ai.getInstance().init();
                    });
                  }
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.restart_alt)),
          IconButton(
              onPressed: () {
                setState(() {
                  if(_themeFactory is BlackThemeFactory){
                    currentLight = lightOn;
                    _themeFactory = BlueThemeFactory();
                  }else{
                    currentLight = lightOff;
                    _themeFactory = BlackThemeFactory();
                  }
                });
              },
              icon: currentLight!),
          IconButton(
              onPressed: () {
                setState(() {
                  if(currentShape == circle){
                    currentShape = rect;
                  } else {
                    currentShape = circle;
                  }
                });
              },
              icon: currentShape!),
        ],
      ),
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  _themeFactory!.getTheme().getThemeColor(),
                  Colors.white,
                ],
                stops: [
                  0.0,
                  1
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.repeated)),
        child: ListView(
          children: [
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding (
                      padding: EdgeInsets.only(top:14,bottom: 30),
                      child: Text(_viewModel.state,style: TextStyle(color: Colors.white),),
                    ),
                    GestureDetector(
                        onTapDown: (topDownDetails) {
                          var position = topDownDetails.localPosition;
                          Chess chess = _viewModel.play(currentShape == circle);
                          setState(() {
                            ChessPainter._position =
                                Position(position.dx, position.dy, chess);
                          });
                        },
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: Size(width, width),
                              painter: CheckerBoardPainter(),
                            ),
                            CustomPaint(
                              size: Size(width, width),
                              painter: ChessPainter(turnAi),
                            )
                          ],
                        ))
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  /// Ai 下棋
  void turnAi() {
    // print("Ai下棋");
    if (ChessPainter._position!.chess is WhiteChess &&
        Ai.getInstance().isWin(ChessPainter._position!.dx ~/ (width / 15),
            ChessPainter._position!.dy ~/ (width / 15), 1)) {
      TipsDialog.show(context, "恭喜", "您打败了决策树算法");
    }
    // 获取Ai下棋地址
    Ai ai = Ai.getInstance();
    ChessPainter._position = ai.searchPosition();
    // 设置棋子外观
    ChessPainter._position!.chess.chessShape = CircleShape();
    // 加入决策中
    Ai.getInstance().addChessman(ChessPainter._position!.dx.toInt(),
        ChessPainter._position!.dy.toInt(), -1);
    if (ChessPainter._position!.chess is BlackChess &&
        Ai.getInstance().isWin(ChessPainter._position!.dx.toInt(),
            ChessPainter._position!.dy.toInt(), -1)) {
      TipsDialog.show(context, "很遗憾", "决策树算法打败了您");
    }
    setState(() {
      ChessPainter._position!.dx = ChessPainter._position!.dx * (width / 15);
      ChessPainter._position!.dy = ChessPainter._position!.dy * (width / 15);
    });
  }
}

class ChessPainter extends CustomPainter {
  static int _state = 0;
  static Position? _position;
  final Function _function;
  Originator _originator = Originator.getInstance();

  ChessPainter(Function f) : _function = f;

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
      var absX =
          (dx - CheckerBoardPainter._crossOverBeanList[i]._dx).abs(); //两个点的x轴距离
      var absY =
          (dy - CheckerBoardPainter._crossOverBeanList[i]._dy).abs(); //两个点的y轴距离
      var s = sqrt(absX * absX +
          absY * absY); //利用直角三角形求斜边公式（a的平方 + b的平方 = c的平方）来计算出两点间的距离
      if (s <= mWidth / 2 - 2) {
        // 触摸点到棋盘坐标坐标点距离小于等于棋子半径，那么
        //找到离触摸点最近的棋盘坐标点并记录保存下来
        _position!.dx = CheckerBoardPainter._crossOverBeanList[i]._dx;
        _position!.dy = CheckerBoardPainter._crossOverBeanList[i]._dy;
        _originator.add(_position!);
        add = true;
        if (_position!.chess is WhiteChess) {
          Ai.getInstance().addChessman(
              _position!.dx ~/ (width / 15), _position!.dy ~/ (width / 15), 1);
        }
        // flag = false; //白子下完了，该黑子下了
        break;
      }
    }

    //画子
    mPaint..style = PaintingStyle.fill;
    if (_originator.state.isNotEmpty) {
      for (int i = 0; i < _originator.state.length; i++) {
        mPaint..color = _originator.state[i].chess.color;
        if (_originator.state[i].chess.chessShape.shape == 1) {
          canvas.drawCircle(
              Offset(_originator.state[i].dx, _originator.state[i].dy),
              min(mWidth / 2, mHeight / 2) - 2,
              mPaint);
        }
        if (_originator.state[i].chess.chessShape.shape == 2) {
          Rect rect = Rect.fromCircle(
              center: Offset(_originator.state[i].dx, _originator.state[i].dy),
              radius: min(mWidth / 2, mHeight / 2) - 2);
          canvas.drawRect(rect, mPaint);
        }
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (add && _position!.chess is WhiteChess) {
        _function();
      }
    });
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
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
    //重绘下整个界面的画布北京颜色
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
    return false;
  }
}

///记录棋盘上横竖线的交叉点
class CrossOverBean {
  double _dx;
  double _dy;

  CrossOverBean(this._dx, this._dy);
}
