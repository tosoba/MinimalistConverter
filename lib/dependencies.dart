import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';

void initDependencyContainer() {
  dependencies.Container()
    ..registerInstance(ConverterBloc(), name: "converter_bloc")
    ..registerFactory(
        (container) => container
            .resolve<ConverterBloc>("converter_bloc")
            .initialRedDisplayState,
        name: "initial_red_display_state")
    ..registerFactory(
        (container) => container
            .resolve<ConverterBloc>("converter_bloc")
            .initialWhiteDisplayState,
        name: "initial_white_display_state")
    ..registerFactory(
        (container) => container
            .resolve<ConverterBloc>("converter_bloc")
            .redCurrencyDisplayEvents,
        name: "red_display_events")
    ..registerFactory(
        (container) => container
            .resolve<ConverterBloc>("converter_bloc")
            .whiteCurrencyDisplayEvents,
        name: "white_display_events")
    ..registerFactory(
        (container) => CurrencyDisplayBloc(
            container
                .resolve<CurrencyDisplayState>("initial_red_display_state"),
            container
                .resolve<Stream<CurrencyDisplayEvent>>("red_display_events")),
        name: "red_currency_display_bloc")
    ..registerFactory(
        (container) => CurrencyDisplayBloc(
            container
                .resolve<CurrencyDisplayState>("initial_white_display_state"),
            container
                .resolve<Stream<CurrencyDisplayEvent>>("white_display_events")),
        name: "white_currency_display_bloc");
}
