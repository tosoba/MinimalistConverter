import 'package:flutter/material.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';

//TODO: fontSizes, fontFamilies, onTaps, texts
// auto size text

class InputPage extends StatelessWidget {
  final CurrencyDisplayType _displayType;

  Color get _backgroundColor =>
      colors[_displayType == CurrencyDisplayType.RED ? "red" : "white"];
  Color get _accentColor =>
      colors[_displayType == CurrencyDisplayType.RED ? "white" : "red"];

  InputPage(this._displayType);

  Widget _tapToDeleteButton(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        'tap to delete',
        style: TextStyle(
            color: _accentColor,
            fontSize: 17.0,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _inputTextField(BuildContext context) {
    return Center(
      child: Text(
        'input',
        style: TextStyle(
            color: _accentColor,
            fontSize: 100.0,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _inputButtonsRow(List<Widget> buttons) {
    return Row(
        children: buttons
            .map((button) => Expanded(
                  flex: 1,
                  child: button,
                ))
            .toList());
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.keyboard_arrow_down,
        color: _accentColor,
      ),
    );
  }

  List<Widget> get _verticalButtonRows {
    return [
      _inputButtonsRow([
        InputButton('1', _accentColor, _backgroundColor),
        InputButton('2', _accentColor, _backgroundColor),
        InputButton('3', _accentColor, _backgroundColor),
      ]),
      _inputButtonsRow([
        InputButton('4', _accentColor, _backgroundColor),
        InputButton('5', _accentColor, _backgroundColor),
        InputButton('6', _accentColor, _backgroundColor),
      ]),
      _inputButtonsRow([
        InputButton('7', _accentColor, _backgroundColor),
        InputButton('8', _accentColor, _backgroundColor),
        InputButton('9', _accentColor, _backgroundColor),
      ]),
      _inputButtonsRow([
        InputButton(',', _accentColor, _backgroundColor),
        InputButton('0', _accentColor, _backgroundColor),
        InputButton('OK', _accentColor, _backgroundColor),
      ]),
    ];
  }

  Widget _mainWidget(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: orientation == Orientation.portrait
            ? Column(
                children: [
                  Expanded(flex: 2, child: _tapToDeleteButton(context)),
                  Expanded(
                    flex: 4,
                    child: _inputTextField(context),
                  )
                ]
                  ..addAll(_verticalButtonRows
                      .map((row) => Expanded(
                            flex: 3,
                            child: row,
                          ))
                      .toList())
                  ..add(Expanded(flex: 2, child: _backButton(context))),
              )
            : Row(
                children: <Widget>[],
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          color: _backgroundColor,
          child: _mainWidget(context),
        ),
      ),
    );
  }
}

//TODO: make it similar to arrow button with ink effect and stuff...
class InputButton extends StatelessWidget {
  final String _text;
  final Color _backgroundColor;
  final Color _textColor;

  InputButton(this._text, this._backgroundColor, this._textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0), color: _backgroundColor),
      child: Center(
        child: Text(
          _text,
          style: TextStyle(
              color: _textColor, fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
