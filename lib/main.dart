import 'package:desktop_demo/excel/parser_excel.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Desktop Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: const MyHomePage(title: 'Flutter Desktop Demo'),
      home: Scaffold(
        appBar: AppBar(title: const Text("Demo")),
        body: const ParserExcelDemo(),
      ),
    );
  }
}
