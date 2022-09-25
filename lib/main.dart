import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/dependencies.dart';
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/pages/converter/converter_page.dart';
import 'package:minimalist_converter/pages/input/input_bloc.dart';

void main() {
  initDependencyContainer();
  runApp(ConverterApp());
}

class ConverterApp extends StatefulWidget {
  @override
  _ConverterAppState createState() => _ConverterAppState();
}

class _ConverterAppState extends State<ConverterApp> {
  final ConverterBloc _converterBloc =
      dependencies.KiwiContainer().resolve<ConverterBloc>("converter_bloc");

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Converter',
        theme: ThemeData(primarySwatch: Colors.red),
        home: BlocProvider(
          child: ConverterPage(),
          create: (BuildContext context) => _converterBloc,
        ),
      );

  @override
  void dispose() {
    _converterBloc.close();
    dependencies.KiwiContainer().resolve<InputBloc>().close();
    super.dispose();
  }
}
