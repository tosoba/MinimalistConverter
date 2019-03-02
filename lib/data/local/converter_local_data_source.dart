import 'package:minimalist_converter/data/model/exchange_rates_response.dart';

class ConverterLocalDataSource {
  final Map<String, Map<String, double>> _cache = Map();

  void storeRatesFrom(ExchangeRatesResponse response) {
    _cache[response.baseCurrencySymbol] = response.exchangeRates;
  }

  Map<String, double> getRatesForCurrencyWith(String symbol) {
    return _cache.containsKey(symbol) ? _cache[symbol] : null;
  }
}
