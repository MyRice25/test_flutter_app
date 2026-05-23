import 'dart:ui';

import 'package:flutter/cupertino.dart';

// 앱 컬러 셋
class AppColors {
  static const Color transparent = Color(0x00000000);
  
  static const Color primary = Color(0xFFFF783C);
  static const Color secondary = Color(0xffFFF1EB);
  static const Color secondary10 = Color(0xffFFF1EC);

  static const Color systemBlue = Color(0xff5D84F9);
  static const Color systemRed = Color(0xffFF783C);

  static const Color colorF5F5F5 = Color(0xffF5F5F5);

  static const Color violet = Color(0xFFBD7DF7);
  static const Color violet100 = Color(0xFFF8F2FE);

  // Grayscale
  static const Color white = Color(0xffFFFFFF);
  static const Color gray100 = Color(0xffF5F6F8);
  static const Color gray200 = Color(0xffE0E1E5);
  static const Color gray300 = Color(0xffC2C2C6);
  static const Color gray400 = Color(0xffADAEB7);
  static const Color gray500 = Color(0xff5E5E60);
  static const Color gray600 = Color(0xff242627);
  static const Color gray700 = Color(0xff4D545D);
  static const Color gray800 = Color(0xff2D343F);

  static const Color appColor = Color(0xff4d55f5);
  static const Color appSubColor = Color(0xffF2895A);
  static const Color appBgBlack = Color(0xff131514);
  static const Color halfBlack = Color(0x88000000);
  static const Color halfWhite = Color(0x88ffffff);
  static const Color hintTextColor = Color(0xff8e8e93);
  static const Color textFieldColor = Color(0xff202020);
  static const Color captionColor = Color(0xffff7765);
  static const Color black20 = Color(0xff202020);

  static const Color grayFontLight = Color(0xffababab);

  static const Color diaryGreen = Color(0xff8fd0bc);
  static const Color diaryRed = Color(0xffff7765);
  static const Color diaryWhite = Color(0xffd9d9d9);

  static const Color stroke = Color(0xfff2f2f2);
  static const Color bgTertiary = Color(0xffe9e9e9);
  static const Color bgSecondary = Color(0xfff8f8f8);
  static const Color bgPrimary = Color(0xffffffff);
  static const Color labelPrimary = Color(0xff121212);
  static const Color labelSecondary = Color(0xff565656);
  static const Color labelTertiary = Color(0xff898989);

  static const Color labelQuaternary = Color(0xffb3b3b3);
  static const Color labelError = Color(0xffff5643);
  static const Color gray738788 = Color(0xff738788);
  static const Color labelWhite = Color(0xfff9f9f9);

  static const Color strokeError = Color(0xffff5643);

  static const Color black = Color(0xff000000);
  static const Color containerBackgroundColor = Color(0xff525050);
  static const Color unselectedBarColor = Color(0xff525151);
  static const Color barTextColor = Color(0xffb8b8b8);
  static const Color secondaryActiveColor = Color(0xffa3a3da);
  static const Color backBottomColor = Color(0xff313031);
  static const Color back05Color = Color(0xff3d3f3c);
  static const Color back9aColor = Color(0xff9a9a9a);
  static const Color back4142Color = Color(0xff414247);
  static const Color back5253Color = Color(0xff525359);
  static const Color back313031Color = Color(0xff313031);
  static const Color yellowTextColor = Color(0xffFDD43F);
  static const Color back9d9d9Color = Color(0xffd9d9d9);
  static const Color greenColor = Color(0xff6eb899);
  static const Color yellowLinarColor = Color(0xfff2af59);
  static const Color greyColor = Color(0xfff3f3f3);

  //방탈출 컬러
  static const Color appBlack = Color(0xff404040);
  static const Color appGrayBG = Color(0xfff4f6f7);
  static const Color appGrayMiddle = Color(0xffdcdcdc);
  static const Color appGrayBtn = Color(0xffa2abaf);

  static const Color white30 = Color(0x48ffffff);

  static const Color color61 = Color(0xff616161);
  static const Color colora9 = Color(0xffa9a9a9);
  static const Color color33 = Color(0xff333333);
  static const Color color96 = Color(0xff969696);
  static const Color colorc8 = Color(0xffc8c8c8);
  static const Color color42 = Color(0xff424242);
  static const Color color44 = Color(0xff444444);
  static const Color color4d = Color(0xff4d4d4d);
  static const Color color55 = Color(0xff555555);
  static const Color colorc7 = Color(0xffc7c7c7);
  static const Color color76 = Color(0xff767676);
  static const Color color7a = Color(0xff7a7a7a);
  static const Color color68 = Color(0xff686868);
  static const Color color22 = Color(0xff222222);
  static const Color colorbc = Color(0xffbcbcbc);
  static const Color color3f = Color(0xff3f3f3f);
  static const Color color9d = Color(0xff9d9d9d);
  static const Color colord4 = Color(0xffd4d4d4);
  static const Color colord7 = Color(0xffd7d7d7);
  static const Color colordc = Color(0xffdcdcdc);
  static const Color colorf0 = Color(0xfff0f0f0);
  static const Color colorf5 = Color(0xfff5f5f5);
  static const Color colord87234 = Color(0xffd87234);
  static const Color colord20808 = Color(0xffd20808);
  static const Color colorfd5858 = Color(0xfffd5858);
  static const Color colorfc0c0c = Color(0xfffc0c0c);
  static const Color coloree1e1e = Color(0xffee1e1e);
  static const Color color08d2d2 = Color(0xff08d2d2);
  static const Color color80 = Color(0xff808080);
  static const Color color88 = Color(0xff888888);
  static const Color colord8dde5 = Color(0xffd8dde5);
  static const Color colorae = Color(0xffaeaeae);
  static const Color colorb3 = Color(0xffb3b3b3);
  static const Color colore0 = Color(0xffe0e0e0);
  static const Color color2dd8d8 = Color(0xff2dd8d8);
  static const Color colorf2f2f2 = Color(0xfff2f2f2);
  static const Color color007aff = Color(0xff007aff);
  static const Color color99 = Color(0xff999999);
  static const Color darkestOcean = Color(0xff014094);

  // 카카오 컬러
  static const Color fillKakao = Color(0xfffee500);

  static const LinearGradient tabMenuGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: const [
      Color(0xffffffe1),
      Color(0xff00d4d7),
      Color(0xff009dbe),
      Color(0xff013b93),
    ],
  );

  static const LinearGradient drillSuccessGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: const [
        Color(0xffffffe1),
        Color(0xff00d4d7),
        Color(0xff009dbe),
        Color(0xff013b93),
      ],
      stops: const [
        0,
        0.13,
        0.56,
        1
      ]);

  static const LinearGradient drillFailGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: const [
        Color(0xfffdfffd),
        Color(0xfffff1bf),
        Color(0xfffdad64),
        Color(0xffff0000),
      ],
      stops: const [
        0,
        0.29,
        0.69,
        1
      ]);
}
