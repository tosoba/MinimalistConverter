import 'package:minimalist_converter/common/models/currency.dart';
import 'package:minimalist_converter/common/values/currencies.dart';

final String defaultDisplayValue = '0';
final double defaultAmountValue = 0;
final Currency defaultInputCurrency =
    currencies.where((c) => c.shortName == 'USD').first;
final Currency defaultOutputCurrency =
    currencies.where((c) => c.shortName == 'EUR').first;
