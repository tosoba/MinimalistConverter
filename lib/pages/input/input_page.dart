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
    final orientation = MediaQuery.of(context).orientation;
    final align = Align(
      alignment: orientation == Orientation.portrait
          ? AlignmentDirectional.center
          : AlignmentDirectional.topCenter,
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
    return orientation == Orientation.portrait
        ? align
        : Padding(
            child: align,
            padding: EdgeInsets.symmetric(vertical: 15.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons
              .map((button) => Expanded(
                    child: button,
                  ))
              .toList()),
    );
  }

  Widget _backButton(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: orientation == Orientation.portrait
          ? EdgeInsets.symmetric(horizontal: 10.0)
          : EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Align(
        alignment: orientation == Orientation.portrait
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.topStart,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: _accentColor,
          ),
        ),
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
        _InputButton(
            _accentColor, _inputButtonIcon(Icons.subdirectory_arrow_left)),
      ]),
    ];
  }

  List<Widget> get _horizontalButtonRows {
    return [
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('1')),
        _InputButton(_accentColor, _inputButtonText('2')),
        _InputButton(_accentColor, _inputButtonText('3')),
        _InputButton(_accentColor, _inputButtonText(',')),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('4')),
        _InputButton(_accentColor, _inputButtonText('5')),
        _InputButton(_accentColor, _inputButtonText('6')),
        _InputButton(_accentColor, _inputButtonText('0')),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('7')),
        _InputButton(_accentColor, _inputButtonText('8')),
        _InputButton(_accentColor, _inputButtonText('9')),
        _InputButton(
            _accentColor, _inputButtonIcon(Icons.subdirectory_arrow_left)),
      ])
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
      Expanded(flex: 2, child: _backAndBackspaceButtonsRow(context)),
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
    widgets.add(Expanded(
      flex: 1,
      child: SizedBox(),
    ));
    return widgets;
  }

  Widget _backAndBackspaceButtonsRow(BuildContext context) {
    return Stack(
      children: <Widget>[_backButton(context), _tapToDeleteButton(context)],
    );
  }

  List<Widget> _horizontalLeftColumnWidgets(BuildContext context) {
    return [
      _backAndBackspaceButtonsRow(context),
      Center(child: _inputTextField(context)),
    ];
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: _horizontalLeftColumnWidgets(context),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: _horizontalButtonRows
                          .map((row) => Expanded(
                                flex: 3,
                                child: row,
                              ))
                          .toList(),
                    ),
                  )
                ],
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
    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.landscape
          ? EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)
          : EdgeInsets.all(0.0),
      child: RawMaterialButton(
        onPressed: () {},
        shape: CircleBorder(),
        fillColor: _backgroundColor,
        elevation: 0.0,
        child: _child,
      ),
    );
  }
}
