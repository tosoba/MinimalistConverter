import 'package:flutter/material.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/models/inset_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:minimalist_converter/common/values/dimensions.dart';

class CurrencyDisplayWidget extends StatelessWidget {
  final CurrencyDisplayType _displayType;
  final String _fontFamily = 'Quicksand';

  final double _arrowButtonSideEdgeInsetValue = arrowButtonDimension / 2 + 15.0;
  final double _differentSideEdgeInsetValue = arrowButtonDimension / 2 - 10.0;

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

  Widget _currencyShortNameWidget() {
    return Text(
      'short name',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: _textColor,
          fontSize: 17.0,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold),
    );
  }

  EdgeInsets _edgeInsets(InsetType insetType, double insetValue) {
    switch (insetType) {
      case InsetType.LEFT:
        return EdgeInsets.only(left: insetValue);
      case InsetType.RIGHT:
        return EdgeInsets.only(right: insetValue);
      case InsetType.TOP:
        return EdgeInsets.only(top: insetValue);
      case InsetType.BOTTOM:
        return EdgeInsets.only(bottom: insetValue);
    }
  }

  List<Widget> _columnWidgets(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      if (_displayType == CurrencyDisplayType.RED) {
        return [
          Padding(
            child: _currencyLongNameWidget(),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          _currencyValueWidget(),
          Padding(
            child: _currencyShortNameWidget(),
            padding:
                _edgeInsets(InsetType.BOTTOM, _arrowButtonSideEdgeInsetValue),
          )
        ];
      } else {
        return [
          Padding(
            child: _currencyShortNameWidget(),
            padding: _edgeInsets(InsetType.TOP, _arrowButtonSideEdgeInsetValue),
          ),
          _currencyValueWidget(),
          Padding(
            child: _currencyLongNameWidget(),
            padding:
                _edgeInsets(InsetType.BOTTOM, _differentSideEdgeInsetValue),
          )
        ];
      }
    } else {
      if (_displayType == CurrencyDisplayType.RED) {
        return [
          Padding(
            child: _currencyLongNameWidget(),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyValueWidget(),
            padding:
                _edgeInsets(InsetType.RIGHT, _arrowButtonSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyShortNameWidget(),
            padding:
                _edgeInsets(InsetType.BOTTOM, _differentSideEdgeInsetValue),
          )
        ];
      } else {
        return [
          Padding(
            child: _currencyLongNameWidget(),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyValueWidget(),
            padding:
                _edgeInsets(InsetType.LEFT, _arrowButtonSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyShortNameWidget(),
            padding:
                _edgeInsets(InsetType.BOTTOM, _differentSideEdgeInsetValue),
          )
        ];
      }
    }
  }

  Widget _mainColumn(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _columnWidgets(context));
  }

  CurrencyDisplayWidget(this._displayType);

  @override
  Widget build(BuildContext context) {
    return Container(color: _backgroundColor, child: _mainColumn(context));
  }
}
