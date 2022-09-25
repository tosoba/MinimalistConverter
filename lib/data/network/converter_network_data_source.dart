import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minimalist_converter/data/model/exchange_rates_response.dart';

class ConverterNetworkDataSource {
  final http.Client client;

  ConverterNetworkDataSource(this.client);

  Future<ExchangeRatesResponse> loadExchangeRates(
    String baseCurrencyShortName,
    String outputCurrencyShortName,
  ) async {
    final uri = Uri.https(
      'api.exchangerate.host',
      'convert',
      {"from": baseCurrencyShortName, "to": outputCurrencyShortName},
    );
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return ExchangeRatesResponse.fromJson(
        json.decode(response.body),
        baseCurrencyShortName,
        outputCurrencyShortName,
      );
    } else {
      return null;
    }
  }
}
