import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
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

  List<Widget> get _currencyDisplays => [
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
    switch (MediaQuery.of(context).orientation) {
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
        child: RawMaterialButton(
      onPressed: () => converterBloc.dispatch(SwapRedAndWhite()),
      child: BlocBuilder(
        bloc: converterBloc,
        builder: (context, ConverterState state) => Icon(
              state.arrowDirection == ArrowDirection.UP
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: colors["red"],
              size: 65,
            ),
      ),
      shape: CircleBorder(side: BorderSide(width: 2.0, color: colors["red"])),
      elevation: 1.0,
      fillColor: Colors.white,
      padding: EdgeInsets.all(25.0),
    ));
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
