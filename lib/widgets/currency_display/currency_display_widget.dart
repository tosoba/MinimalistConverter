import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/models/inset_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:minimalist_converter/common/values/dimensions.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';

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

  Widget _currencyLongNameWidget(String text) => InkWell(
      onTap: () {},
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _textColor, fontSize: 22.0, fontFamily: _fontFamily),
      ));

  Widget _currencyValueWidget(String text) => Center(
        child: InkWell(
            onTap: () {},
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _textColor, fontSize: 120.0, fontFamily: _fontFamily),
            )),
      );

  Widget _currencyShortNameWidget(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _textColor,
            fontSize: 17.0,
            fontFamily: _fontFamily,
            fontWeight: FontWeight.bold),
      );

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

  List<Widget> _columnWidgets(
      BuildContext context, CurrencyDisplayState state) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      if (_displayType == CurrencyDisplayType.RED) {
        return [
          Padding(
            child: _currencyLongNameWidget(state.currency.longName),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          _currencyValueWidget(state.displayValue),
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding:
                _edgeInsets(InsetType.BOTTOM, _arrowButtonSideEdgeInsetValue),
          )
        ];
      } else {
        return [
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding: _edgeInsets(InsetType.TOP, _arrowButtonSideEdgeInsetValue),
          ),
          _currencyValueWidget(state.displayValue),
          Padding(
            child: _currencyLongNameWidget(state.currency.longName),
            padding:
                _edgeInsets(InsetType.BOTTOM, _differentSideEdgeInsetValue),
          )
        ];
      }
    } else {
      if (_displayType == CurrencyDisplayType.RED) {
        return [
          Padding(
            child: _currencyLongNameWidget(state.currency.longName),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyValueWidget(state.displayValue),
            padding:
                _edgeInsets(InsetType.RIGHT, _arrowButtonSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding:
                _edgeInsets(InsetType.BOTTOM, _differentSideEdgeInsetValue),
          )
        ];
      } else {
        return [
          Padding(
            child: _currencyLongNameWidget(state.currency.longName),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyValueWidget(state.displayValue),
            padding:
                _edgeInsets(InsetType.LEFT, _arrowButtonSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding:
                _edgeInsets(InsetType.BOTTOM, _differentSideEdgeInsetValue),
          )
        ];
      }
    }
  }

  Widget _mainColumn(BuildContext context) {
    final CurrencyDisplayBloc bloc =
        BlocProvider.of<CurrencyDisplayBloc>(context);
    return BlocBuilder(
        bloc: bloc,
        builder: (context, CurrencyDisplayState state) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _columnWidgets(context, state));
        });
  }

  CurrencyDisplayWidget(this._displayType);

  @override
  Widget build(BuildContext context) {
    return Container(color: _backgroundColor, child: _mainColumn(context));
  }
}
