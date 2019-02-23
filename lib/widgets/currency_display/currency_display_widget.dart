import 'package:flutter/material.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';

//TODO: padding to avoid overlapping with arrow button in the middle

class CurrencyDisplayWidget extends StatelessWidget {
  final CurrencyDisplayType _displayType;
  final String _fontFamily = 'Quicksand';

  Color get _backgroundColor => colors[_displayType];

  Color get _textColor {
    switch (_displayType) {
      case CurrencyDisplayType.RED:
        return colors[CurrencyDisplayType.WHITE];
      case CurrencyDisplayType.WHITE:
        return colors[CurrencyDisplayType.RED];
    }
  }

  Widget _currencyLongNameWidget() => InkWell(
      onTap: () {},
      child: Text(
        'long name',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _textColor, fontSize: 22.0, fontFamily: _fontFamily),
      ));

  Widget _currencyValueWidget() => Center(
        child: InkWell(
            onTap: () {},
            child: Text(
              'value',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _textColor, fontSize: 120.0, fontFamily: _fontFamily),
            )),
      );

  Widget _currencyShortNameWidget() => Text(
        'short name',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _textColor,
            fontSize: 17.0,
            fontFamily: _fontFamily,
            fontWeight: FontWeight.bold),
      );

  OrientationBuilder _mainColumn() =>
      OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait &&
            _displayType == CurrencyDisplayType.WHITE) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _currencyShortNameWidget(),
              _currencyValueWidget(),
              _currencyLongNameWidget()
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _currencyLongNameWidget(),
              _currencyValueWidget(),
              _currencyShortNameWidget()
            ],
          );
        }
      });

  CurrencyDisplayWidget(this._displayType);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      child: _mainColumn()
    );
  }
}
