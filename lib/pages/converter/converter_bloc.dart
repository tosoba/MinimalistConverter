import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/pages/converter/converter_event.dart';
import 'package:minimalist_converter/pages/converter/converter_state.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';
import 'package:rxdart/rxdart.dart';

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
      initialState.redCurrency, initialState.redAmount.toString());

  CurrencyDisplayState get initialWhiteDisplayState => CurrencyDisplayState(
      initialState.whiteCurrency, initialState.whiteAmount.toString());

  @override
  ConverterState get initialState => ConverterState.initial();

  //TODO: extract side effects (passing events to currency display subjects to a mapper function passed via constructor - later maybe dependency injected)
  @override
  Stream<ConverterState> mapEventToState(
      ConverterState currentState, ConverterEvent event) async* {
    if (event is UpdateAmount) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toString()));
          yield currentState..redAmount = event.amount;
          break;
        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toString()));
          yield currentState..whiteAmount = event.amount;
          break;
      }
    } else if (event is UpdateCurrency) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          yield currentState..redCurrency = event.currency;
          break;
        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          yield currentState..whiteCurrency = event.currency;
          break;
      }
    } else if (event is SwapRedAndWhite) {
      final revertedState = ConverterState.reverted(currentState);

      _redCurrencyDisplaySubject
          .add(UpdateCurrencyAmount(revertedState.redAmount.toString()));
      _whiteCurrencyDisplaySubject
          .add(UpdateCurrencyAmount(revertedState.whiteAmount.toString()));
      _redCurrencyDisplaySubject
          .add(UpdateDisplayedCurrency(revertedState.redCurrency));
      _whiteCurrencyDisplaySubject
          .add(UpdateDisplayedCurrency(revertedState.whiteCurrency));

      yield revertedState;
    }
  }

  @override
  void dispose() {
    //TODO: check if this is necessary...
    _redCurrencyDisplaySubject.close();
    _whiteCurrencyDisplaySubject.close();
    super.dispose();
  }
}
