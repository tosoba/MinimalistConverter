import 'package:flutter/material.dart';
import 'package:minimalist_converter/common/models/currency.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:minimalist_converter/common/values/currencies.dart';
import 'package:minimalist_converter/common/values/fonts.dart';

class CurrencyListPage extends StatelessWidget {
  final CurrencyDisplayType _displayType;

  CurrencyListPage(this._displayType);

  Color get _backgroundColor =>
      AppColors.backgroundForCurrencyDisplayType(_displayType);

  Color get _accentColor =>
      AppColors.accentForCurrencyDisplayType(_displayType);

  Widget _backButton(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: RawMaterialButton(
        shape: CircleBorder(),
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: _accentColor),
      ),
    );
  }

  Widget _currenciesList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _CurrencyListItem(
        currencies[index],
        _displayType,
      ),
      itemCount: currencies.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Material(
        child: Container(
          color: _backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: statusBarHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _backButton(context),
                Expanded(child: _currenciesList(context))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrencyListItem extends StatelessWidget {
  final Currency _currency;
  final CurrencyDisplayType _displayType;

  Color get _longNameColor =>
      AppColors.accentForCurrencyDisplayType(_displayType);

  Color get _shortNameColor =>
      AppColors.accentForCurrencyDisplayType(_displayType);

  _CurrencyListItem(this._currency, this._displayType);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => Navigator.pop(context, _currency),
      shape: BeveledRectangleBorder(),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _currency.longName,
              style: TextStyle(
                fontSize: 17,
                color: _longNameColor,
                fontFamily: AppFonts.quicksand,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: Text(
                _currency.shortName,
                style: TextStyle(
                  fontSize: 15,
                  color: _shortNameColor,
                  fontFamily: AppFonts.quicksand,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
