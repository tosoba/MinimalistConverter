import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as dependencies;
import 'package:minimalist_converter/dependencies.dart';
import 'package:minimalist_converter/pages/converter/converter_bloc.dart';
import 'package:minimalist_converter/pages/converter/converter_page.dart';

void main() {
  initDependencyContainer();
  runApp(ConverterApp());
}

class ConverterApp extends StatelessWidget {
  final ConverterBloc _converterBloc =
      dependencies.Container().resolve<ConverterBloc>("converter_bloc");

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Converter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BlocProvider(
        child: ConverterPage(),
        bloc: _converterBloc,
      ));
}
