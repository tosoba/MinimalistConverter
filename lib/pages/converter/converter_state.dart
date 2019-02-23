import 'package:minimalist_converter/common/models/currency.dart';
import 'package:minimalist_converter/common/values/default_values.dart';

class ConverterState {
  Currency redCurrency;
  double redAmount;
  Currency whiteCurrency;
  double whiteAmount;
  ArrowDirection arrowDirection;

  ConverterState._();

  factory ConverterState.initial() => ConverterState._()
    ..redCurrency = defaultInputCurrency
    ..redAmount = defaultAmountValue
    ..whiteCurrency = defaultOutputCurrency
    ..whiteAmount = defaultAmountValue
    ..arrowDirection = ArrowDirection.DOWN;
}

enum ArrowDirection {
  UP, // means that upper display acts as output for converstion result and bottom as input for conversion
  DOWN // means the same as above the other way around
}
