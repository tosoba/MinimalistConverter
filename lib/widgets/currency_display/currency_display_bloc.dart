import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';

class CurrencyDisplayBloc
    extends Bloc<CurrencyDisplayEvent, CurrencyDisplayState> {
  final CurrencyDisplayState _initialState;
  final Stream<CurrencyDisplayEvent> _eventsFromConverter;

  CurrencyDisplayBloc(this._initialState, this._eventsFromConverter) {
    _eventsFromConverter.listen((event) {
      dispatch(event);
    });
  }

  @override
  CurrencyDisplayState get initialState => _initialState;

  @override
  Stream<CurrencyDisplayState> mapEventToState(
      CurrencyDisplayState currentState, CurrencyDisplayEvent event) async* {
    if (event is UpdateCurrencyAmount) {
      yield CurrencyDisplayState(currentState.currency, event.newDisplayValue);
    } else if (event is UpdateDisplayedCurrency) {
      yield CurrencyDisplayState(event.newCurrency, currentState.displayValue);
    }
  }
}
