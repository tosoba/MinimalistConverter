import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/pages/converter/converter_event.dart';
import 'package:minimalist_converter/pages/converter/converter_state.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_widget.dart';

class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final CurrencyDisplayBloc _redDisplayBloc = dependencies.Container()
      .resolve<CurrencyDisplayBloc>("red_currency_display_bloc");

  final CurrencyDisplayBloc _whiteDisplayBloc = dependencies.Container()
      .resolve<CurrencyDisplayBloc>("white_currency_display_bloc");

  List<Widget> get _currencyDisplays =>
      [
        Expanded(
          flex: 1,
          child: BlocProvider(
              child: CurrencyDisplayWidget(CurrencyDisplayType.RED),
              bloc: _redDisplayBloc),
        ),
        Expanded(
            flex: 1,
            child: BlocProvider(
                child: CurrencyDisplayWidget(CurrencyDisplayType.WHITE),
                bloc: _whiteDisplayBloc)),
      ];

  Widget _mainDisplay(BuildContext context) {
    switch (MediaQuery
        .of(context)
        .orientation) {
      case Orientation.portrait:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _currencyDisplays,
        );
      case Orientation.landscape:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _currencyDisplays,
        );
    }
  }

  Widget _arrowButton(BuildContext context) {
    final converterBloc = BlocProvider.of<ConverterBloc>(context);
    return Center(
        child: Container(
            height: 125.0,
            width: 125.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(62.5),
                color: Colors.white,
                border: Border.all(
                    color: Color(0xFFEC5759),
                    style: BorderStyle.solid,
                    width: 5.0)),
            child: BlocBuilder(
              bloc: converterBloc,
              builder: (context, ConverterState state) =>
                  GestureDetector(
                    onTap: () => converterBloc.dispatch(SwapRedAndWhite()),
                    child: Center(
                        child: Icon(
                          state.arrowDirection == ArrowDirection.UP
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 60.0,
                          color: Color(0xFFEC5759),
                        )),
                  ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Stack(
          children: <Widget>[_mainDisplay(context), _arrowButton(context)],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _redDisplayBloc.dispose();
    _whiteDisplayBloc.dispose();
    super.dispose();
  }
}
