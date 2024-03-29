import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/common/models/currency.dart';
import 'package:minimalist_converter/common/models/currency_display_type.dart';
import 'package:minimalist_converter/common/values/colors.dart';
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/pages/converter/converter_event.dart';
import 'package:minimalist_converter/pages/converter/converter_state.dart';
import 'package:minimalist_converter/pages/currency_list/currency_list_page.dart';
import 'package:minimalist_converter/pages/input/input_bloc.dart';
import 'package:minimalist_converter/pages/input/input_page.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_bloc.dart';
import 'package:minimalist_converter/widgets/currency_display/currency_display_widget.dart';

class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage>
    with TickerProviderStateMixin {
  final CurrencyDisplayBloc _redDisplayBloc = dependencies.KiwiContainer()
      .resolve<CurrencyDisplayBloc>("red_currency_display_bloc");
  final CurrencyDisplayBloc _whiteDisplayBloc = dependencies.KiwiContainer()
      .resolve<CurrencyDisplayBloc>("white_currency_display_bloc");

  bool wasOffline = false;

  List<Widget> get _currencyDisplays => [
        Expanded(
          flex: 1,
          child: BlocProvider(
            child: CurrencyDisplayWidget(
                CurrencyDisplayType.RED,
                _showInputPageAndHandleResult,
                _showCurrencyListPageAndHandleResult),
            create: (BuildContext context) => _redDisplayBloc,
          ),
        ),
        Expanded(
            flex: 1,
            child: BlocProvider(
              child: CurrencyDisplayWidget(
                  CurrencyDisplayType.WHITE,
                  _showInputPageAndHandleResult,
                  _showCurrencyListPageAndHandleResult),
              create: (BuildContext context) => _whiteDisplayBloc,
            )),
      ];

  void _showInputPageAndHandleResult(
      BuildContext context, CurrencyDisplayType displayType) async {
    final result = await _showInputPage(context, displayType);

    if (result != null) {
      double amount = double.tryParse(result) ?? 0.0;
      BlocProvider.of<ConverterBloc>(context)
          .add(UpdateAmount(displayType, amount));
    }
  }

  Future<String> _showInputPage(
      BuildContext context, CurrencyDisplayType displayType) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                child: InputPage(displayType),
                create: (BuildContext context) => InputBloc(),
              )),
    );
  }

  void _showCurrencyListPageAndHandleResult(
      BuildContext context, CurrencyDisplayType displayType) async {
    final result = await _showCurrenciesList(context, displayType);
    if (result != null) {
      BlocProvider.of<ConverterBloc>(context)
          .add(UpdateCurrency(displayType, result));
    }
  }

  Future<Currency> _showCurrenciesList(
      BuildContext context, CurrencyDisplayType displayType) async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CurrencyListPage(displayType)));
  }

  Widget _mainDisplay(BuildContext context) {
    switch (MediaQuery.of(context).orientation) {
      case Orientation.portrait:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _currencyDisplays,
        );
      case Orientation.landscape:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _currencyDisplays,
        );
    }
  }

  Widget _arrowButton(BuildContext context) {
    final converterBloc = BlocProvider.of<ConverterBloc>(context);
    final size = 65.0;
    return Center(
        child: RawMaterialButton(
      onPressed: () => converterBloc.add(SwapRedAndWhite()),
      child: BlocBuilder(
        bloc: converterBloc,
        builder: (context, ConverterState state) {
          final orientation = MediaQuery.of(context).orientation;
          if (state.isLoading) {
            return Container(
              width: size,
              height: size,
              child: Center(
                child: SpinKitWave(
                  color: AppColors.red,
                ),
              ),
            );
          } else {
            return Icon(
              state.arrowDirection == ArrowDirection.TOWARDS_RED
                  ? (orientation == Orientation.portrait)
                      ? Icons.arrow_upward
                      : Icons.arrow_back
                  : (orientation == Orientation.portrait)
                      ? Icons.arrow_downward
                      : Icons.arrow_forward,
              color: AppColors.red,
              size: size,
            );
          }
        },
      ),
      shape: CircleBorder(side: BorderSide(width: 2.0, color: AppColors.red)),
      elevation: 1.0,
      fillColor: Colors.white,
      padding: EdgeInsets.all(25.0),
    ));
  }

  //TODO: dispatch last action after going back online again if it failed before because of no internet
  Widget _mainBody(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final connected = connectivity != ConnectivityResult.none;
        final connectionInfoBox = Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          height: 24.0,
          child: Container(
            color: connected ? Colors.green : Colors.red,
            child: Center(
              child: Text(
                "${connected ? 'ONLINE' : 'OFFLINE'}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        Widget returnedWidget;
        if (connected) {
          if (wasOffline) {
            BlocProvider.of<ConverterBloc>(context)
                .add(RetryAfterGoingOnline());
            _onlineMessageAnimationController.forward(from: 0.0);
            final onlineMessage = _OnlineMessage(
              connectionInfoBox,
              _onlineMessageVisibilityDuration,
              animation: StepTween(
                begin: 0,
                end: _onlineMessageVisibilityDuration,
              ).animate(_onlineMessageAnimationController),
            );
            returnedWidget = Stack(
              children: <Widget>[child, onlineMessage],
            );
          } else {
            returnedWidget = Stack(
              children: <Widget>[child],
            );
          }
        } else {
          returnedWidget = Stack(
            children: <Widget>[child, connectionInfoBox],
          );
        }
        wasOffline = !connected;
        return returnedWidget;
      },
      child: Stack(
        children: <Widget>[_mainDisplay(context), _arrowButton(context)],
      ),
    );
  }

  final int _onlineMessageVisibilityDuration = 6;
  AnimationController _onlineMessageAnimationController;

  @override
  void initState() {
    super.initState();
    _onlineMessageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _onlineMessageVisibilityDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(child: _mainBody(context)),
    );
  }

  @override
  void dispose() {
    _redDisplayBloc.close();
    _whiteDisplayBloc.close();
    super.dispose();
  }
}

class _OnlineMessage extends AnimatedWidget {
  final Animation<int> animation;
  final Widget _child;
  final int _animationDurationSeconds;

  _OnlineMessage(
    this._child,
    this._animationDurationSeconds, {
    Key key,
    @required this.animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    if (animation.value < _animationDurationSeconds) return _child;
    return Container();
  }
}
