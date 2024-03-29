import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/models/inset_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:minimalist_converter/common/values/dimensions.dart';
import 'package:minimalist_converter/common/values/fonts.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_state.dart';

class CurrencyDisplayWidget extends StatelessWidget {
  final CurrencyDisplayType _displayType;
  final Function(BuildContext, CurrencyDisplayType) _onValueWidgetPressed;
  final Function(BuildContext, CurrencyDisplayType) _onLongNameWidgetPressed;

  final double _arrowButtonSideEdgeInsetValue = arrowButtonDimension / 2 + 15.0;
  final double _differentSideEdgeInsetValue = arrowButtonDimension / 2 - 20.0;

  Color get _backgroundColor =>
      AppColors.backgroundForCurrencyDisplayType(_displayType);

  Color get _textColor => AppColors.accentForCurrencyDisplayType(_displayType);

  Widget _currencyLongNameWidget(String text, BuildContext context) => Center(
        child: RawMaterialButton(
          onPressed: () async =>
              await _onLongNameWidgetPressed(context, _displayType),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 22.0,
                fontFamily: AppFonts.quicksand,
              ),
            ),
          ),
        ),
      );

  Widget _currencyValueWidget(String text, BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontSize = (MediaQuery.of(context).orientation == Orientation.portrait
            ? height / 8
            : height / 4)
        .floorToDouble();
    return Center(
      child: RawMaterialButton(
          onPressed: () async => await _onValueWidgetPressed(
                context,
                _displayType,
              ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: AutoSizeText(
              text,
              maxLines: 1,
              maxFontSize: fontSize,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: fontSize,
                fontFamily: AppFonts.quicksand,
              ),
            ),
          )),
    );
  }

  Widget _currencyShortNameWidget(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _textColor,
          fontSize: 17.0,
          fontFamily: AppFonts.quicksand,
          fontWeight: FontWeight.bold,
        ),
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
            child: _currencyLongNameWidget(state.currency.longName, context),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          _currencyValueWidget(state.displayValue, context),
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding: _edgeInsets(
              InsetType.BOTTOM,
              _arrowButtonSideEdgeInsetValue,
            ),
          )
        ];
      } else {
        return [
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding: _edgeInsets(InsetType.TOP, _arrowButtonSideEdgeInsetValue),
          ),
          _currencyValueWidget(state.displayValue, context),
          Padding(
            child: _currencyLongNameWidget(state.currency.longName, context),
            padding: _edgeInsets(
              InsetType.BOTTOM,
              _differentSideEdgeInsetValue,
            ),
          )
        ];
      }
    } else {
      if (_displayType == CurrencyDisplayType.RED) {
        return [
          Padding(
            child: _currencyLongNameWidget(state.currency.longName, context),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyValueWidget(state.displayValue, context),
            padding: _edgeInsets(
              InsetType.RIGHT,
              _arrowButtonSideEdgeInsetValue,
            ),
          ),
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding: _edgeInsets(
              InsetType.BOTTOM,
              _differentSideEdgeInsetValue,
            ),
          )
        ];
      } else {
        return [
          Padding(
            child: _currencyLongNameWidget(state.currency.longName, context),
            padding: _edgeInsets(InsetType.TOP, _differentSideEdgeInsetValue),
          ),
          Padding(
            child: _currencyValueWidget(state.displayValue, context),
            padding: _edgeInsets(
              InsetType.LEFT,
              _arrowButtonSideEdgeInsetValue,
            ),
          ),
          Padding(
            child: _currencyShortNameWidget(state.currency.shortName),
            padding: _edgeInsets(
              InsetType.BOTTOM,
              _differentSideEdgeInsetValue,
            ),
          )
        ];
      }
    }
  }

  Widget _mainColumn(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<CurrencyDisplayBloc>(context),
        builder: (context, CurrencyDisplayState state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _columnWidgets(context, state),
          );
        });
  }

  CurrencyDisplayWidget(
    this._displayType,
    this._onValueWidgetPressed,
    this._onLongNameWidgetPressed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(color: _backgroundColor, child: _mainColumn(context));
  }
}
