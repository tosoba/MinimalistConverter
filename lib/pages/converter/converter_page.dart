import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_widget.dart';

class ConverterPage extends StatelessWidget {
  List<Widget> _currencyDisplays(BuildContext context) {
    final converterBloc = BlocProvider.of<ConverterBloc>(context);
    return [
      Expanded(
        flex: 1,
        child: BlocProvider(
          child: CurrencyDisplayWidget(CurrencyDisplayType.RED),
          bloc: CurrencyDisplayBloc(converterBloc.initialRedDisplayState,
              converterBloc.redCurrencyDisplayEvents),
        ),
      ),
      Expanded(
          flex: 1, child: BlocProvider(
          child: CurrencyDisplayWidget(CurrencyDisplayType.WHITE),
          bloc: CurrencyDisplayBloc(converterBloc.initialWhiteDisplayState,
              converterBloc.whiteCurrencyDisplayEvents),
        )),
    ];
  }

  Widget _mainDisplay(BuildContext context) => OrientationBuilder(
        builder: (context, orientation) {
          switch (orientation) {
            case Orientation.portrait:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _currencyDisplays(context),
              );
            case Orientation.landscape:
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _currencyDisplays(context),
              );
          }
        },
      );

  Widget get _arrowButton => Center(
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
        child: Center(
          //TODO: onTap
          child: true //TODO
              ? Icon(
                  Icons.arrow_upward,
                  size: 60.0,
                  color: Color(0xFFEC5759),
                )
              : Icon(
                  Icons.arrow_downward,
                  size: 60.0,
                  color: Color(0xFFEC5759),
                ),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ConverterBloc>(context);

    return Scaffold(
      body: Material(
        child: Stack(
          children: <Widget>[_mainDisplay(context), _arrowButton],
        ),
      ),
    );
  }
}
