import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/pages/converter/converter_event.dart';
import 'package:minimalist_converter/pages/converter/converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  @override
  ConverterState get initialState => ConverterState.initial();

  @override
  Stream<ConverterState> mapEventToState(
      ConverterState currentState, ConverterEvent event) async* {
    if (event is UpdateAmount) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          yield currentState..redAmount = event.amount;
          break;
        case CurrencyDisplayType.WHITE:
          yield currentState..whiteAmount = event.amount;
          break;
      }
    } else if (event is UpdateCurrency) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          yield currentState..redCurrency = event.currency;
          break;
        case CurrencyDisplayType.WHITE:
          yield currentState..whiteCurrency = event.currency;
          break;
      }
    } else if (event is SwapRedAndWhite) {
      //TODO: see if this works...
      yield currentState
        ..whiteCurrency = currentState.redCurrency
        ..redCurrency = currentState.whiteCurrency
        ..redAmount = currentState.whiteAmount
        ..whiteAmount = currentState.redAmount;
    }
  }
}
