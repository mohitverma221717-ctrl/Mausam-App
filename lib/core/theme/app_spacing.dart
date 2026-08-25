import 'package:flutter/material.dart';

/// Layout Spacing Constants
class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double massive = 48.0;

  // EdgeInsets Helpers
  static const EdgeInsets pNone = EdgeInsets.zero;
  static const EdgeInsets pXs = EdgeInsets.all(xs);
  static const EdgeInsets pSm = EdgeInsets.all(sm);
  static const EdgeInsets pMd = EdgeInsets.all(md);
  static const EdgeInsets pLg = EdgeInsets.all(lg);
  static const EdgeInsets pXl = EdgeInsets.all(xl);
  static const EdgeInsets pXxl = EdgeInsets.all(xxl);

  // Screen Padding
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets screenPaddingHorizontal =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets modalPadding = EdgeInsets.all(24.0);

  // SizedBox Spacers
  static const SizedBox gapH4 = SizedBox(width: xs);
  static const SizedBox gapH8 = SizedBox(width: sm);
  static const SizedBox gapH12 = SizedBox(width: md);
  static const SizedBox gapH16 = SizedBox(width: lg);
  static const SizedBox gapH20 = SizedBox(width: xl);
  static const SizedBox gapH24 = SizedBox(width: xxl);

  static const SizedBox gapV4 = SizedBox(height: xs);
  static const SizedBox gapV8 = SizedBox(height: sm);
  static const SizedBox gapV12 = SizedBox(height: md);
  static const SizedBox gapV16 = SizedBox(height: lg);
  static const SizedBox gapV20 = SizedBox(height: xl);
  static const SizedBox gapV24 = SizedBox(height: xxl);
  static const SizedBox gapV32 = SizedBox(height: xxxl);
  static const SizedBox gapV48 = SizedBox(height: massive);
}
