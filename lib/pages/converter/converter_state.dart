import 'package:minimalist_converter/common/models/currency.dart';
import 'package:minimalist_converter/common/values/default_values.dart';

class ConverterState {
  Currency _redCurrency;
  double _redAmount;
  Currency _whiteCurrency;
  double _whiteAmount;
  ArrowDirection _arrowDirection;
  bool _isLoading;

  Currency get redCurrency => _redCurrency;

  double get redAmount => _redAmount;

  Currency get whiteCurrency => _whiteCurrency;

  double get whiteAmount => _whiteAmount;

  ArrowDirection get arrowDirection => _arrowDirection;

  bool get isLoading => _isLoading;

  ConverterState._();

  factory ConverterState.initial() {
    return ConverterState._()
      .._redCurrency = defaultInputCurrency
      .._redAmount = defaultAmountValue
      .._whiteCurrency = defaultOutputCurrency
      .._whiteAmount = defaultAmountValue
      .._arrowDirection = ArrowDirection.TOWARDS_WHITE
      .._isLoading = false;
  }

  factory ConverterState.withRevertedCurrenciesAndArrowDirection(
    ConverterState other,
  ) {
    return ConverterState._()
      .._redAmount = other._redAmount
      .._whiteAmount = other._whiteAmount
      .._redCurrency = other._whiteCurrency
      .._whiteCurrency = other._redCurrency
      .._arrowDirection = other._arrowDirection == ArrowDirection.TOWARDS_RED
          ? ArrowDirection.TOWARDS_WHITE
          : ArrowDirection.TOWARDS_RED
      .._isLoading = other.isLoading;
  }

  ConverterState copyWith({
    Currency redCurrency,
    double redAmount,
    Currency whiteCurrency,
    double whiteAmount,
    ArrowDirection arrowDirection,
    bool isLoading,
  }) {
    redCurrency ??= this.redCurrency;
    redAmount ??= this.redAmount;
    whiteCurrency ??= this.whiteCurrency;
    whiteAmount ??= this.whiteAmount;
    arrowDirection ??= this.arrowDirection;
    isLoading ??= this.isLoading;
    return ConverterState._()
      .._redCurrency = redCurrency
      .._redAmount = redAmount
      .._whiteCurrency = whiteCurrency
      .._whiteAmount = whiteAmount
      .._arrowDirection = arrowDirection
      .._isLoading = isLoading;
  }
}

enum ArrowDirection {
  TOWARDS_RED, // means that red display acts as output for conversion result and white as input for conversion
  TOWARDS_WHITE // means the same as above the other way around
}
