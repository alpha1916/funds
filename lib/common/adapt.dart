import 'package:flutter/material.dart';
import 'dart:ui';

class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topBarH = mediaQuery.padding.top;
  static double _bottomBarH = mediaQuery.padding.bottom;
  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static var _ratio;

  //开发时使用的xr模拟器，分辨率为1792x828
  static final _designWidth = 828;
  static init(int number){
    int uiWidth = number is int ? number : _designWidth;
    _ratio = _width / uiWidth;
  }
  static px(number) {
    if(!(_ratio is double || _ratio is int)){
      Adapt.init(_designWidth);
    }
    
    return number * _ratio;
  }
  
  static one(){
    return 1 / _pixelRatio;
  }
  
  static screenW(){
    return _width;
  }
  
  static screenH(){
    return _height;
  }
  
  static padTopH(){
    return _topBarH;
  }
  
  static padBotH(){
    return _bottomBarH;
  }
}