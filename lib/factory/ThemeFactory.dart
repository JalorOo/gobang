import 'package:gobang/factory/UserTheme.dart';

import 'Theme.dart';

abstract class ThemeFactory{
  Theme getTheme();
}

class UserThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new UserTheme();
  }
}

class AiThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new AiTheme();
  }
}