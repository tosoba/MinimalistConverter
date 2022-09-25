import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';

class CurrencyDisplayBloc
    extends Bloc<CurrencyDisplayEvent, CurrencyDisplayState> {
  final Stream<CurrencyDisplayEvent> _eventsFromConverter;

  CurrencyDisplayBloc(
    CurrencyDisplayState _initialState,
    this._eventsFromConverter,
  ) : super(_initialState) {
    _eventsFromConverter.listen((event) {
      add(event);
    });

    on<UpdateCurrencyAmount>((event, emit) =>
        emit(CurrencyDisplayState(state.currency, event.newDisplayValue)));
    on<UpdateDisplayedCurrency>((event, emit) =>
        emit(CurrencyDisplayState(event.newCurrency, state.displayValue)));
  }
}
