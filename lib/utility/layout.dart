import 'dart:math';

import 'package:flutter/widgets.dart';

// iPhone 8 screen
const _referenceWidth = 375;
const _referenceHeight = 667;
const _referenceRatio = _referenceHeight / _referenceWidth;
const _maxWidth = 680;

// set default values for widget tests
double _vw = _referenceWidth / 100;
double _vh = _referenceHeight / 100;

/// Returns 1/100th of the viewport's width multiplied with [factor].
double vw([double factor = 1]) => factor * _vw;

/// Returns 1/100th of the viewport's height multiplied with [factor].
double vh([double factor = 1]) => factor * _vh;

/// Returns 1 styleguide dimension unit, adapted for the current viewport, multiplied with [factor].
double dp(double factor) => vw(factor * 100 / _referenceWidth);

double screenRatio = _referenceRatio;

void initLayout(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  screenRatio = screenSize.height / screenSize.width;
  final adjustedWidth = screenRatio < _referenceRatio ? screenSize.height / _referenceRatio : screenSize.width;

  _vw = min(adjustedWidth, _maxWidth) / 100;
  _vh = screenSize.height / 100;
}

void responsive(BuildContext context) => MediaQuery.of(context);
