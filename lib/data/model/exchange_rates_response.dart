class ExchangeRatesResponse {
  final String baseCurrencySymbol;
  final Map<String, double> exchangeRates;

  ExchangeRatesResponse._(this.baseCurrencySymbol, this.exchangeRates);

  factory ExchangeRatesResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('rates') && json.containsKey('base'))
      return ExchangeRatesResponse._(json['base'], json['rates']);
    else
      return null;
  }
}
