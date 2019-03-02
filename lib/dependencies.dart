import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:http/http.dart' as http;
import 'package:minimalist_converter/data/local/converter_local_data_source.dart';
import 'package:minimalist_converter/data/network/converter_network_data_source.dart';
import 'package:minimalist_converter/data/repository/converter_repository.dart';
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/pages/input/input_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_event.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';

void initDependencyContainer() {
  dependencies.Container()
    ..registerInstance(http.Client())
    ..registerFactory(
        (container) => ConverterNetworkDataSource(container.resolve()))
    ..registerSingleton((container) => ConverterLocalDataSource())
    ..registerFactory((container) =>
        ConverterRepository(container.resolve(), container.resolve()))
    ..registerSingleton((container) => ConverterBloc(container.resolve()),
        name: "converter_bloc")
    ..registerSingleton((container) => container.resolve<ConverterBloc>("converter_bloc").initialRedDisplayState,
        name: "initial_red_display_state")
    ..registerSingleton((container) => container.resolve<ConverterBloc>("converter_bloc").initialWhiteDisplayState,
        name: "initial_white_display_state")
    ..registerSingleton((container) => container.resolve<ConverterBloc>("converter_bloc").redCurrencyDisplayEvents,
        name: "red_display_events")
    ..registerSingleton(
        (container) => container
            .resolve<ConverterBloc>("converter_bloc")
            .whiteCurrencyDisplayEvents,
        name: "white_display_events")
    ..registerSingleton(
        (container) => CurrencyDisplayBloc(
            container
                .resolve<CurrencyDisplayState>("initial_red_display_state"),
            container
                .resolve<Stream<CurrencyDisplayEvent>>("red_display_events")),
        name: "red_currency_display_bloc")
    ..registerSingleton(
        (container) => CurrencyDisplayBloc(
            container.resolve<CurrencyDisplayState>("initial_white_display_state"),
            container.resolve<Stream<CurrencyDisplayEvent>>("white_display_events")),
        name: "white_currency_display_bloc")
    ..registerSingleton((container) => InputBloc());
}
