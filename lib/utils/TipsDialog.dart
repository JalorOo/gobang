import 'package:flutter/material.dart';

class TipsDialog{
  static show(BuildContext context,String title,tips) async {
    await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Text(tips)
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static wait(BuildContext context,String title,tips) async {
    await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Text(tips)
              ],
            ),
          ),
        );
      },
    );
  }

  static showByChoose(BuildContext context,String title,tips,yes,no,Function f) async {
    await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Text(tips)
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text(no),
              onPressed: () {
                f(false);
              },
            ),
            new TextButton(
              child: new Text(yes),
              onPressed: () {
                f(true);
              },
            ),
          ],
        );
      },
    );
  }
}