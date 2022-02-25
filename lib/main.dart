import 'package:desktop_demo/database/insert_employee.dart';
import 'package:desktop_demo/excel/parser_excel.dart';
import 'package:desktop_demo/routers.dart';
import 'package:desktop_demo/test_widget.dart';
import 'package:flutter/material.dart';

import 'db_demo.dart';

void main() async {
  Routers().register(Routers.pageEmployee, const EmployeeDatabase());
  Routers().register(Routers.pageInsert, const InsertEmployeePage());
  Routers().register(Routers.pageUpdate, const InsertEmployeePage());
  Routers().register(Routers.pageParserExcel, const ParserExcelDemo());
  Routers().register(Routers.pageDropdownButton, const DropdownButtonDemo());
  Routers().register(Routers.pageDropdownMenu, const TextFieldDemo());
  Routers().register(Routers.pageTextField, const TextFieldDemo());
  runApp(const MyApp());
}

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
                      onPressed: () => Routers().push(context, Routers.pageParserExcel),
                      child: const Text("Excel Parser")),
                  TextButton(
                    onPressed: () => Routers().push(context, Routers.pageEmployee),
                    child: const Text("Employee Database"),
                  ),
                  TextButton(
                      onPressed: () => Routers().push(context, Routers.pageDropdownButton),
                      child: const Text("DropdownButton")),
                  TextButton(
                      onPressed: () => Routers().push(context, Routers.pageDropdownMenu),
                      child: const Text("PopupMenuButton")),
                  TextButton(
                      onPressed: () => Routers().push(context, Routers.pageTextField),
                      child: const Text("TextFieldDemo")),
                ],
              ),
            );
          })),
    );
  }
}
