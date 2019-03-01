import 'package:flutter/material.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    return Center(
      child: InkWell(
        onTap: () {},
        child: Text(
          'tap to delete',
          style: TextStyle(
              color: _accentColor,
              fontSize: 17.0,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _inputTextField(BuildContext context) {
    return Center(
      child: AutoSizeText(
        'input',
        maxLines: 1,
        style: TextStyle(
            color: _accentColor,
            fontSize: 90.0,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _inputButtonsRow(List<Widget> buttons) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons
              .map((button) => Expanded(
                    child: button,
                  ))
              .toList()),
    );
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
        _InputButton(_accentColor, _inputButtonText('1')),
        _InputButton(_accentColor, _inputButtonText('2')),
        _InputButton(_accentColor, _inputButtonText('3')),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('4')),
        _InputButton(_accentColor, _inputButtonText('5')),
        _InputButton(_accentColor, _inputButtonText('6')),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('7')),
        _InputButton(_accentColor, _inputButtonText('8')),
        _InputButton(_accentColor, _inputButtonText('9')),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText(',')),
        _InputButton(_accentColor, _inputButtonText('0')),
        _InputButton(_accentColor, _inputButtonIcon(Icons.subdirectory_arrow_left)),
      ]),
    ];
  }

  Widget _inputButtonText(String text) {
    return Text(
      text,
      style: TextStyle(color: _backgroundColor, fontSize: 30.0),
    );
  }

  Widget _inputButtonIcon(IconData iconData) {
    return Icon(
      iconData,
      color: _backgroundColor,
      size: 30.0,
    );
  }

  List<Widget> _verticalColumnWidgets(BuildContext context) {
    final widgets = [
      Expanded(flex: 2, child: _tapToDeleteButton(context)),
      Expanded(
        flex: 4,
        child: _inputTextField(context),
      )
    ];
    widgets.addAll(_verticalButtonRows
        .map((row) => Expanded(
              flex: 3,
              child: row,
            ))
        .toList());
    widgets.add(Expanded(flex: 2, child: _backButton(context)));
    return widgets;
  }

  Widget _mainWidget(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: orientation == Orientation.portrait
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _verticalColumnWidgets(context))
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
class _InputButton extends StatelessWidget {
  final Color _backgroundColor;
  final Widget _child;

  _InputButton(this._backgroundColor, this._child);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      shape: CircleBorder(),
      fillColor: _backgroundColor,
      elevation: 0.0,
      child: _child,
    );
  }
}
