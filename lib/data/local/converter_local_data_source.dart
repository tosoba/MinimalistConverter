import 'package:minimalist_converter/data/model/exchange_rates_response.dart';

class ConverterLocalDataSource {
  final Map<String, Map<String, double>> _cache = Map();

  void storeRatesFrom(ExchangeRatesResponse response) {
    _cache[response.baseCurrencyShortName] = response.exchangeRates;
  }

  Map<String, double> getRatesForCurrencyWith(String shortName) {
    return _cache.containsKey(shortName) ? _cache[shortName] : null;
  }
}
