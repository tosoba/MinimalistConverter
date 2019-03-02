import 'package:minimalist_converter/data/local/converter_local_data_source.dart';
import 'package:minimalist_converter/data/network/converter_network_data_source.dart';

class ConverterRepository {
  final ConverterNetworkDataSource _network;
  final ConverterLocalDataSource _local;

  ConverterRepository(this._network, this._local);

  Future<double> loadExchangeRate(String baseCurrencySymbol) async {
    final cached = _local.getRatesForCurrencyWith(baseCurrencySymbol);
    if (cached == null) {
      final response = await _network.loadExchangeRates(baseCurrencySymbol);
      if (response == null) return null;
      _local.storeRatesFrom(response);
      return response.exchangeRates[baseCurrencySymbol];
    } else {
      return cached[baseCurrencySymbol];
    }
  }
}
