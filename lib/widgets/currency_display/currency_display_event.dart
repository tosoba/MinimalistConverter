import 'package:minimalist_converter/common/models/currency.dart';

abstract class CurrencyDisplayEvent {}

class UpdateDisplayedCurrency extends CurrencyDisplayEvent {
  final Currency newCurrency;

  UpdateDisplayedCurrency(this.newCurrency);
}

class UpdateCurrencyAmount extends CurrencyDisplayEvent {
  final String newDisplayValue;

  UpdateCurrencyAmount(this.newDisplayValue);
}