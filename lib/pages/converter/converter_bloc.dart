import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/data/repository/converter_repository.dart';
import 'package:minimalist_converter/pages/converter/converter_event.dart';
import 'package:minimalist_converter/pages/converter/converter_state.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';
import 'package:rxdart/rxdart.dart';

class _JustUpdateAmount extends ConverterUpdateEvent {
  final double amount;

  _JustUpdateAmount(CurrencyDisplayType type, this.amount) : super(type);
}

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final PublishSubject<CurrencyDisplayEvent> _redCurrencyDisplaySubject =
      PublishSubject();
  final PublishSubject<CurrencyDisplayEvent> _whiteCurrencyDisplaySubject =
      PublishSubject();

  Stream<CurrencyDisplayEvent> get redCurrencyDisplayEvents =>
      _redCurrencyDisplaySubject.stream.distinct();

  Stream<CurrencyDisplayEvent> get whiteCurrencyDisplayEvents =>
      _whiteCurrencyDisplaySubject.stream.distinct();

  CurrencyDisplayState get initialRedDisplayState => CurrencyDisplayState(
      initialState.redCurrency, initialState.redAmount.toStringAsFixed(2));

  CurrencyDisplayState get initialWhiteDisplayState => CurrencyDisplayState(
      initialState.whiteCurrency,
      initialState.whiteAmount.toStringAsFixed(2));

  final ConverterRepository _repository;

  ConverterBloc(this._repository) : super();

  @override
  ConverterState get initialState => ConverterState.initial();

  _loadExchangeRateAndDispatchUpdateAmount(
      String baseCurrencyShortName,
      String outputCurrencyShortName,
      double baseCurrencyAmount,
      CurrencyDisplayType outputDisplayType) async {
    final rate = await _repository.loadExchangeRate(
        baseCurrencyShortName, outputCurrencyShortName);
    if (rate == null) {
      return; //TODO: error handling
    }

    final outputAmount = baseCurrencyAmount * rate;
    dispatch(_JustUpdateAmount(
        outputDisplayType, num.parse(outputAmount.toStringAsFixed(2))));
  }

  @override
  Stream<ConverterState> mapEventToState(
      ConverterState currentState, ConverterEvent event) async* {
    //TODO: check arrow direction - perform request to db/api if needed
    if (event is UpdateAmount) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          if (currentState.arrowDirection == ArrowDirection.TOWARDS_RED) {
            yield currentState.copyWith(
                redAmount: event.amount,
                arrowDirection: ArrowDirection.TOWARDS_WHITE);
          } else {
            yield currentState.copyWith(redAmount: event.amount);
          }

          await _loadExchangeRateAndDispatchUpdateAmount(
              currentState.redCurrency.shortName,
              currentState.whiteCurrency.shortName,
              event.amount,
              CurrencyDisplayType.WHITE);
          break;

        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          if (currentState.arrowDirection == ArrowDirection.TOWARDS_WHITE) {
            yield currentState.copyWith(
                whiteAmount: event.amount,
                arrowDirection: ArrowDirection.TOWARDS_RED);
          } else {
            yield currentState.copyWith(whiteAmount: event.amount);
          }

          await _loadExchangeRateAndDispatchUpdateAmount(
              currentState.whiteCurrency.shortName,
              currentState.redCurrency.shortName,
              event.amount,
              CurrencyDisplayType.RED);
          break;
      }
    } else if (event is UpdateCurrency) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          yield currentState.copyWith(redCurrency: event.currency);

          await _loadExchangeRateAndDispatchUpdateAmount(
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? currentState.whiteCurrency.shortName
                  : event.currency.shortName,
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? event.currency.shortName
                  : currentState.whiteCurrency.shortName,
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? currentState.whiteAmount
                  : currentState.redAmount,
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? CurrencyDisplayType.RED
                  : CurrencyDisplayType.WHITE);
          break;

        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          yield currentState.copyWith(whiteCurrency: event.currency);

          await _loadExchangeRateAndDispatchUpdateAmount(
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? event.currency.shortName
                  : currentState.redCurrency.shortName,
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? currentState.redCurrency.shortName
                  : event.currency.shortName,
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? currentState.whiteAmount
                  : currentState.redAmount,
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? CurrencyDisplayType.RED
                  : CurrencyDisplayType.WHITE);
          break;
      }
    } else if (event is SwapRedAndWhite) {
      final revertedState =
          ConverterState.withRevertedCurrenciesAndArrowDirection(currentState);

      _redCurrencyDisplaySubject
          .add(UpdateDisplayedCurrency(revertedState.redCurrency));
      _whiteCurrencyDisplaySubject
          .add(UpdateDisplayedCurrency(revertedState.whiteCurrency));

      yield revertedState;

      await _loadExchangeRateAndDispatchUpdateAmount(
          revertedState.arrowDirection == ArrowDirection.TOWARDS_RED
              ? revertedState.whiteCurrency.shortName
              : revertedState.redCurrency.shortName,
          revertedState.arrowDirection == ArrowDirection.TOWARDS_RED
              ? revertedState.redCurrency.shortName
              : revertedState.whiteCurrency.shortName,
          revertedState.arrowDirection == ArrowDirection.TOWARDS_RED
              ? revertedState.whiteAmount
              : revertedState.redAmount,
          revertedState.arrowDirection == ArrowDirection.TOWARDS_RED
              ? CurrencyDisplayType.RED
              : CurrencyDisplayType.WHITE);
    } else if (event is _JustUpdateAmount) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          yield currentState.copyWith(redAmount: event.amount);
          break;

        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          yield currentState.copyWith(whiteAmount: event.amount);
          break;
      }
    }
  }

  @override
  void dispose() {
    _redCurrencyDisplaySubject.close();
    _whiteCurrencyDisplaySubject.close();
    super.dispose();
  }
}
