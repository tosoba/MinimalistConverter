import 'dart:async';

import 'package:minimalist_converter/data/local/converter_local_data_source.dart';
import 'package:minimalist_converter/data/network/converter_network_data_source.dart';

class ConverterRepository {
  final ConverterNetworkDataSource _network;
  final ConverterLocalDataSource _local;

  ConverterRepository(this._network, this._local);

  Future<double> loadExchangeRate(
      String baseCurrencyShortName, String outputCurrencyShortName) async {
    final cachedRate = _local.getRate(
      baseCurrencyShortName,
      outputCurrencyShortName,
    );
    if (cachedRate == null) {
      try {
        final response = await _network.loadExchangeRates(
          baseCurrencyShortName,
          outputCurrencyShortName,
        );
        if (response == null) return null;
        _local.storeRatesFrom(response);
        return response.rate;
      } catch (e) {
        return null;
      }
    } else {
      return cachedRate;
    }
  }
}
