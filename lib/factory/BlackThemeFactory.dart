import 'BlackTheme.dart';
import 'Theme.dart';
import 'ThemeFactory.dart';

class BlackThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new BlackTheme();
  }
}