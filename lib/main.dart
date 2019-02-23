import 'package:flutter/material.dart';
import 'package:minimalist_converter/pages/converter/converter_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: ConverterPage());
}
