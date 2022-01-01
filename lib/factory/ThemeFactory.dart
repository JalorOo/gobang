import 'package:gobang/factory/UserTheme.dart';

import 'Theme.dart';

abstract class ThemeFactory{
  Theme getTheme();
}

class YellowThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new YellowTheme();
  }
}

class BlueThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new BlueTheme();
  }
}

class BlackThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new BlackTheme();
  }
}