import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minimalist_converter/data/model/exchange_rates_response.dart';

class ConverterNetworkDataSource {
  final http.Client client;

  final String baseUrl = "https://api.exchangeratesapi.io/latest";

  ConverterNetworkDataSource(this.client);

  Future<ExchangeRatesResponse> loadExchangeRates(
      String baseCurrencySymbol) async {
    final urlEncoded = Uri.encodeFull('$baseUrl?base=$baseCurrencySymbol');
    final response = await client.get(urlEncoded);
    if (response.statusCode == 200)
      return ExchangeRatesResponse.fromJson(json.decode(response.body));
    else
      return null;
  }
}
