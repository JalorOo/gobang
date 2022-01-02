import 'BlueTheme.dart';
import 'Theme.dart';
import 'ThemeFactory.dart';

class BlueThemeFactory extends ThemeFactory{
  @override
  Theme getTheme() {
    return new BlueTheme();
  }
}