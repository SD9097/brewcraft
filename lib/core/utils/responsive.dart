import 'package:flutter/material.dart';

import '../constants/breakpoints.dart';

enum ScreenSize { mobile, tablet, desktop }

ScreenSize screenSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < Breakpoints.mobile) return ScreenSize.mobile;
  if (width < Breakpoints.tablet) return ScreenSize.tablet;
  return ScreenSize.desktop;
}

int gridColumnsFor(BuildContext context) {
  return switch (screenSizeOf(context)) {
    ScreenSize.mobile => 1,
    ScreenSize.tablet => 2,
    ScreenSize.desktop => 3,
  };
}

double pagePaddingFor(BuildContext context) {
  return switch (screenSizeOf(context)) {
    ScreenSize.mobile => 16,
    ScreenSize.tablet => 32,
    ScreenSize.desktop => 48,
  };
}
