import 'package:bloc/bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/data/repository/converter_repository.dart';
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

  final ConverterRepository _repository;

  ConverterBloc(this._repository) : super();

  @override
  ConverterState get initialState => ConverterState.initial();

  @override
  Stream<ConverterState> mapEventToState(
      ConverterState currentState, ConverterEvent event) async* {
    //TODO: check arrow direction - perform request to db/api if needed
    if (event is UpdateAmount) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toString()));
          if (currentState.arrowDirection == ArrowDirection.TOWARDS_RED) {
            yield currentState.copyWith(
                redAmount: event.amount,
                arrowDirection: ArrowDirection.TOWARDS_WHITE);
          } else {
            yield currentState.copyWith(redAmount: event.amount);
          }
          break;
        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateCurrencyAmount(event.amount.toString()));
          if (currentState.arrowDirection == ArrowDirection.TOWARDS_WHITE) {
            yield currentState.copyWith(
                whiteAmount: event.amount,
                arrowDirection: ArrowDirection.TOWARDS_RED);
          } else {
            yield currentState.copyWith(whiteAmount: event.amount);
          }
          break;
      }
    } else if (event is UpdateCurrency) {
      switch (event.type) {
        case CurrencyDisplayType.RED:
          _redCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          yield currentState.copyWith(redCurrency: event.currency);
          break;
        case CurrencyDisplayType.WHITE:
          _whiteCurrencyDisplaySubject
              .add(UpdateDisplayedCurrency(event.currency));
          yield currentState.copyWith(whiteCurrency: event.currency);
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
    } else if (event is ChangeArrowDirection) {
      yield currentState.copyWith(
          arrowDirection:
              currentState.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? ArrowDirection.TOWARDS_WHITE
                  : ArrowDirection.TOWARDS_RED);
    }
  }

  @override
  void dispose() {
    _redCurrencyDisplaySubject.close();
    _whiteCurrencyDisplaySubject.close();
    super.dispose();
  }
}
