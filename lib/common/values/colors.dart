import 'package:flutter/material.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';

class AppColors {
  static final Color red = Color(0xFFEC5759);
  static final Color white = Colors.white;

  static Color backgroundForCurrencyDisplayType(CurrencyDisplayType type) =>
      type == CurrencyDisplayType.RED ? red : white;

  static Color accentForCurrencyDisplayType(CurrencyDisplayType type) =>
      type == CurrencyDisplayType.RED ? white : red;
}
