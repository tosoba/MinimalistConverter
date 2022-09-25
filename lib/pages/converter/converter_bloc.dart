import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/data/repository/converter_repository.dart';
import 'package:minimalist_converter/pages/converter/converter_event.dart';
import 'package:minimalist_converter/pages/converter/converter_state.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';
import 'package:rxdart/rxdart.dart';

class _JustUpdateAmountAndFinishLoading extends ConverterUpdateEvent {
  final double amount;

  _JustUpdateAmountAndFinishLoading(CurrencyDisplayType type, this.amount)
      : super(type);
}

class _StartLoading extends ConverterEvent {}

class _JustFinishLoading extends ConverterEvent {}

class _LoadExchangeRatesArgs {
  final String baseCurrencyShortName;
  final String outputCurrencyShortName;
  final double baseCurrencyAmount;
  final CurrencyDisplayType outputDisplayType;

  _LoadExchangeRatesArgs(
    this.baseCurrencyShortName,
    this.outputCurrencyShortName,
    this.baseCurrencyAmount,
    this.outputDisplayType,
  );
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
      _initialState.redCurrency, _initialState.redAmount.toStringAsFixed(2));

  CurrencyDisplayState get initialWhiteDisplayState => CurrencyDisplayState(
      _initialState.whiteCurrency,
      _initialState.whiteAmount.toStringAsFixed(2));

  final ConverterRepository _repository;
  final ConverterState _initialState;

  _LoadExchangeRatesArgs _argsToRetry;

  ConverterBloc(this._repository, this._initialState) : super(_initialState) {
    on<UpdateAmount>((event, emit) async {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          if (state.arrowDirection == ArrowDirection.TOWARDS_RED) {
            emit(
              state.copyWith(
                redAmount: event.amount,
                arrowDirection: ArrowDirection.TOWARDS_WHITE,
              ),
            );
          } else {
            emit(state.copyWith(redAmount: event.amount));
          }

          await _loadExchangeRateAndDispatchUpdateAmount(
            state.redCurrency.shortName,
            state.whiteCurrency.shortName,
            event.amount,
            CurrencyDisplayType.WHITE,
          );
          break;

        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          if (state.arrowDirection == ArrowDirection.TOWARDS_WHITE) {
            emit(state.copyWith(
              whiteAmount: event.amount,
              arrowDirection: ArrowDirection.TOWARDS_RED,
            ));
          } else {
            emit(state.copyWith(whiteAmount: event.amount));
          }

          await _loadExchangeRateAndDispatchUpdateAmount(
            state.whiteCurrency.shortName,
            state.redCurrency.shortName,
            event.amount,
            CurrencyDisplayType.RED,
          );
          break;
      }
    });

    on<UpdateCurrency>((event, emit) async {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          emit(state.copyWith(redCurrency: event.currency));

          await _loadExchangeRateAndDispatchUpdateAmount(
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? state.whiteCurrency.shortName
                : event.currency.shortName,
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? event.currency.shortName
                : state.whiteCurrency.shortName,
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? state.whiteAmount
                : state.redAmount,
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? CurrencyDisplayType.RED
                : CurrencyDisplayType.WHITE,
          );
          break;

        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          emit(state.copyWith(whiteCurrency: event.currency));

          await _loadExchangeRateAndDispatchUpdateAmount(
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? event.currency.shortName
                : state.redCurrency.shortName,
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? state.redCurrency.shortName
                : event.currency.shortName,
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? state.whiteAmount
                : state.redAmount,
            state.arrowDirection == ArrowDirection.TOWARDS_RED
                ? CurrencyDisplayType.RED
                : CurrencyDisplayType.WHITE,
          );
          break;
      }
    });

    on<SwapRedAndWhite>((event, emit) async {
      final revertedState =
          ConverterState.withRevertedCurrenciesAndArrowDirection(state);

      _redCurrencyDisplaySubject
          .add(UpdateDisplayedCurrency(revertedState.redCurrency));
      _whiteCurrencyDisplaySubject
          .add(UpdateDisplayedCurrency(revertedState.whiteCurrency));

      emit(revertedState);

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
            : CurrencyDisplayType.WHITE,
      );
    });

    on<_JustUpdateAmountAndFinishLoading>((event, emit) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          emit(state.copyWith(redAmount: event.amount, isLoading: false));
          break;

        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toStringAsFixed(2)));
          emit(state.copyWith(whiteAmount: event.amount, isLoading: false));
          break;
      }
    });

    on<RetryAfterGoingOnline>((event, emit) async {
      if (_argsToRetry != null) {
        await _loadExchangeRateAndDispatchUpdateAmount(
          _argsToRetry.baseCurrencyShortName,
          _argsToRetry.outputCurrencyShortName,
          _argsToRetry.baseCurrencyAmount,
          _argsToRetry.outputDisplayType,
        );
      }
    });

    on<_JustFinishLoading>(
        (event, emit) => emit(state.copyWith(isLoading: false)));

    on<_StartLoading>((event, emit) => emit(state.copyWith(isLoading: true)));
  }

  _loadExchangeRateAndDispatchUpdateAmount(
      String baseCurrencyShortName,
      String outputCurrencyShortName,
      double baseCurrencyAmount,
      CurrencyDisplayType outputDisplayType) async {
    add(_StartLoading());
    final rate = await _repository.loadExchangeRate(
      baseCurrencyShortName,
      outputCurrencyShortName,
    );
    if (rate == null) {
      _argsToRetry = _LoadExchangeRatesArgs(
        baseCurrencyShortName,
        outputCurrencyShortName,
        baseCurrencyAmount,
        outputDisplayType,
      );
      add(_JustFinishLoading());
      return;
    }

    _argsToRetry = null;
    final outputAmount = baseCurrencyAmount * rate;
    add(
      _JustUpdateAmountAndFinishLoading(
        outputDisplayType,
        num.parse(outputAmount.toStringAsFixed(2)),
      ),
    );
  }

  @override
  Future<void> close() async {
    _redCurrencyDisplaySubject.close();
    _whiteCurrencyDisplaySubject.close();
    super.close();
  }
}
