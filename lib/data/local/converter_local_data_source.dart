import 'package:minimalist_converter/data/model/exchange_rates_response.dart';

class ConverterLocalDataSource {
  final Map<String, double> _cache = Map();

  void storeRatesFrom(ExchangeRatesResponse response) {
    _cache[_cacheKey(
            response.baseCurrencyShortName, response.outputCurrencyShortName)] =
        response.rate;
  }

  String _cacheKey(
          String baseCurrencyShortName, String outputCurrencyShortName) =>
      baseCurrencyShortName + "-" + outputCurrencyShortName;

  double getRate(String baseCurrencyShortName, String outputCurrencyShortName) {
    final key = _cacheKey(baseCurrencyShortName, outputCurrencyShortName);
    return _cache.containsKey(key) ? _cache[key] : null;
  }
}
