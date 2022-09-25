class ExchangeRatesResponse {
  final String baseCurrencyShortName;
  final String outputCurrencyShortName;
  final double rate;

  ExchangeRatesResponse._(
    this.baseCurrencyShortName,
    this.outputCurrencyShortName,
    this.rate,
  );

  factory ExchangeRatesResponse.fromJson(
    Map<String, dynamic> json,
    String baseCurrencyShortName,
    String outputCurrencyShortName,
  ) {
    if (json.containsKey('result')) {
      return ExchangeRatesResponse._(
        baseCurrencyShortName,
        outputCurrencyShortName,
        json['result'] as double,
      );
    } else {
      return null;
    }
  }
}
