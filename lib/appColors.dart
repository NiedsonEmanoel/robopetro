import 'package:flutter/material.dart';
enum modScreen {light, dark}

class appColors {
  Color _backgroundColor;
  Color _hintTextColor;
  Color _textColor;
  bool isDarkSetted;
  bool isLightSetted;

  appColors(var mode) {
    setColors(mode);
  }

  void setColors(var mode) {
    switch(mode) {
      case modScreen.dark:
        this._backgroundColor = Colors.black87;
        this._hintTextColor = Colors.white;
        this._textColor = Colors.white;
        isDarkSetted = true;
        isLightSetted = false;
      break;

      case modScreen.light:
        this._backgroundColor = Colors.white;
        this._hintTextColor = Colors.black38;
        this._textColor = Colors.black;
        isLightSetted = true;
        isDarkSetted = false;
      break;
    }
  }

  Color get textColor{
    return this._textColor;
  }

  Color get hintTextColor{
    return this._hintTextColor;
  }

  Color get backgroundColor{
    return this._backgroundColor;
  }
}