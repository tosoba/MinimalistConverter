import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:minimalist_converter/common/values/fonts.dart';
import 'package:minimalist_converter/pages/input/input_bloc.dart';
import 'package:minimalist_converter/pages/input/input_event.dart';
import 'package:minimalist_converter/pages/input/input_state.dart';

class InputPage extends StatefulWidget {
  final CurrencyDisplayType _displayType;

  InputPage(this._displayType);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Color get _backgroundColor =>
      AppColors.backgroundForCurrencyDisplayType(widget._displayType);

  Color get _accentColor =>
      AppColors.accentForCurrencyDisplayType(widget._displayType);

  Widget _tapToDeleteButton(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final align = Align(
      alignment: orientation == Orientation.portrait
          ? AlignmentDirectional.center
          : AlignmentDirectional.topCenter,
      child: InkWell(
        onTap: () =>
            BlocProvider.of<InputBloc>(context).dispatch(RemoveLastCharacter()),
        child: Text(
          'tap to delete',
          style: TextStyle(
              color: _accentColor,
              fontSize: 17.0,
              fontFamily: AppFonts.quicksand,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Padding(
      child: align,
      padding: EdgeInsets.symmetric(vertical: 15.0),
    );
  }

  Widget _inputTextField(BuildContext context) {
    return Center(
      child: BlocBuilder(
        bloc: BlocProvider.of<InputBloc>(context),
        builder: (context, InputState state) => AutoSizeText(
              state.input,
              maxLines: 1,
              style: TextStyle(
                  color: _accentColor,
                  fontSize: 90.0,
                  fontFamily: AppFonts.quicksand,
                  fontWeight: FontWeight.bold),
            ),
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
    return Align(
      alignment: MediaQuery.of(context).orientation == Orientation.portrait
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.topStart,
      child: RawMaterialButton(
        onPressed: () => Navigator.pop(context),
        shape: CircleBorder(),
        child: Icon(
          Icons.arrow_back,
          color: _accentColor,
        ),
      ),
    );
  }

  Function _onInputButtonTextPressed(String character, BuildContext context) {
    return () => BlocProvider.of<InputBloc>(context)
        .dispatch(AppendNewCharacter(character));
  }

  Function _onSubmitButtonPressed(BuildContext context) {
    return () => Navigator.pop(
        context, BlocProvider.of<InputBloc>(context).currentState.input);
  }

  List<Widget> _verticalButtonRows(BuildContext context) {
    return [
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('1'),
            _onInputButtonTextPressed('1', context)),
        _InputButton(_accentColor, _inputButtonText('2'),
            _onInputButtonTextPressed('2', context)),
        _InputButton(_accentColor, _inputButtonText('3'),
            _onInputButtonTextPressed('3', context)),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('4'),
            _onInputButtonTextPressed('4', context)),
        _InputButton(_accentColor, _inputButtonText('5'),
            _onInputButtonTextPressed('5', context)),
        _InputButton(_accentColor, _inputButtonText('6'),
            _onInputButtonTextPressed('6', context)),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('7'),
            _onInputButtonTextPressed('7', context)),
        _InputButton(_accentColor, _inputButtonText('8'),
            _onInputButtonTextPressed('8', context)),
        _InputButton(_accentColor, _inputButtonText('9'),
            _onInputButtonTextPressed('9', context)),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText(','),
            _onInputButtonTextPressed(',', context)),
        _InputButton(_accentColor, _inputButtonText('0'),
            _onInputButtonTextPressed('0', context)),
        _InputButton(
            _accentColor,
            _inputButtonIcon(Icons.subdirectory_arrow_left),
            _onSubmitButtonPressed(context)),
      ]),
    ];
  }

  List<Widget> _horizontalButtonRows(BuildContext context) {
    return [
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('1'),
            _onInputButtonTextPressed('1', context)),
        _InputButton(_accentColor, _inputButtonText('2'),
            _onInputButtonTextPressed('2', context)),
        _InputButton(_accentColor, _inputButtonText('3'),
            _onInputButtonTextPressed('3', context)),
        _InputButton(_accentColor, _inputButtonText(','),
            _onInputButtonTextPressed(',', context)),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('4'),
            _onInputButtonTextPressed('4', context)),
        _InputButton(_accentColor, _inputButtonText('5'),
            _onInputButtonTextPressed('5', context)),
        _InputButton(_accentColor, _inputButtonText('6'),
            _onInputButtonTextPressed('6', context)),
        _InputButton(_accentColor, _inputButtonText('0'),
            _onInputButtonTextPressed('0', context)),
      ]),
      _inputButtonsRow([
        _InputButton(_accentColor, _inputButtonText('7'),
            _onInputButtonTextPressed('7', context)),
        _InputButton(_accentColor, _inputButtonText('8'),
            _onInputButtonTextPressed('8', context)),
        _InputButton(_accentColor, _inputButtonText('9'),
            _onInputButtonTextPressed('9', context)),
        _InputButton(
            _accentColor,
            _inputButtonIcon(Icons.subdirectory_arrow_left),
            _onSubmitButtonPressed(context)),
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
    widgets.addAll(_verticalButtonRows(context)
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
      children: <Widget>[
        _backButton(context),
        _tapToDeleteButton(context),
      ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: _horizontalButtonRows(context)
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
  void initState() {
    super.initState();
    dependencies.Container().resolve<InputBloc>().dispatch(Clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: _backgroundColor,
        child: _mainWidget(context),
      ),
    );
  }
}

class _InputButton extends StatelessWidget {
  final Color _backgroundColor;
  final Widget _child;
  final Function _onPressed;

  _InputButton(this._backgroundColor, this._child, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.landscape
          ? EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)
          : EdgeInsets.all(0.0),
      child: RawMaterialButton(
        onPressed: _onPressed,
        shape: CircleBorder(),
        fillColor: _backgroundColor,
        elevation: 0.0,
        child: _child,
      ),
    );
  }
}
