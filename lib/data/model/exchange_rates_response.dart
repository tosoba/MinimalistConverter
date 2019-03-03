class ExchangeRatesResponse {
  final String baseCurrencyShortName;
  final Map<String, double> exchangeRates;

  ExchangeRatesResponse._(this.baseCurrencyShortName, this.exchangeRates);

  factory ExchangeRatesResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('rates') && json.containsKey('base'))
      return ExchangeRatesResponse._(
          json['base'], json['rates'].cast<String, double>());
    else
      return null;
  }
}
