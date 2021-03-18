import 'dart:math';
import 'dart:ui';

class ColorCorrection {

  static bool useDarkColor(Color background) {
    double red = pow(background.red / 255, 2.2);
    double green = pow(background.green / 255, 2.2);
    double blue = pow(background.blue / 255, 2.2);

    double brightness = 0.2126 * red + 0.7151 * green + 0.0721 * blue;

    return brightness > 0.7;
  }

}