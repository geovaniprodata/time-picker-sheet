import 'dart:ui';

extension YinYang on Color {
  bool get isLight => (0.299 * red) + (0.587 * green) + (0.114 * blue) > 128;

  bool get isDark => !isLight;
}
