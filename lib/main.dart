import 'package:desktop_demo/excel/parser_excel.dart';
import 'package:desktop_demo/test_widget.dart';
import 'package:flutter/material.dart';

import 'db_demo.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Desktop Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          appBar: AppBar(title: const Text("Demo")),
          body: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ParserExcelDemo()));
                      },
                      child: const Text("Excel Parser")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DatabaseDemo()));
                      },
                      child: const Text("Employee")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const TestDropdownButtonDemo()));
                      },
                      child: const Text("DropdownButton")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const TestPopupMenuButtonDemo()));
                      },
                      child: const Text("PopupMenuButton")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TestTextFieldDemo()));
                      },
                      child: const Text("TextFieldDemo")),
                ],
              ),
            );
          })),
    );
  }
}
