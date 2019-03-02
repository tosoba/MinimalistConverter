import 'package:minimalist_converter/common/models/currency.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';

abstract class ConverterEvent {}

abstract class ConverterUpdateEvent extends ConverterEvent {
  final CurrencyDisplayType type;

  ConverterUpdateEvent(this.type);
}

class UpdateCurrency extends ConverterUpdateEvent {
  final Currency currency;

  UpdateCurrency(CurrencyDisplayType type, this.currency) : super(type);
}

class UpdateAmount extends ConverterUpdateEvent {
  final double amount;

  UpdateAmount(CurrencyDisplayType type, this.amount) : super(type);
}

class SwapRedAndWhite extends ConverterEvent {}

class ChangeArrowDirection extends ConverterEvent {}
