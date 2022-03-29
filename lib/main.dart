import 'package:desktop_demo/database/import_excel.dart';
import 'package:desktop_demo/database/insert_employee.dart';
import 'package:desktop_demo/database/search.dart';
import 'package:desktop_demo/excel/parser_excel.dart';
import 'package:desktop_demo/routers.dart';
import 'package:desktop_demo/test_widget.dart';
import 'package:flutter/material.dart';

import 'database/employee_db.dart';

void main() async {
  Routers().register(Routers.pageEmployee, const EmployeeDatabase());
  Routers().register(Routers.pageInsert, const InsertEmployeePage());
  Routers().register(Routers.pageUpdate, const InsertEmployeePage());
  Routers().register(Routers.pageParserExcel, const ParserExcelDemo());
  Routers().register(Routers.pageDropdownButton, const DropdownButtonDemo());
  Routers().register(Routers.pageDropdownMenu, const TextFieldDemo());
  Routers().register(Routers.pageTextField, const TextFieldDemo());
  Routers().register(Routers.pageSearch, const SearchEmployee());
  Routers().register(Routers.pageImport, const ImportExcel());
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
          appBar: AppBar(title: const Text("人员信息库")),
          body: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(6),
              child: InkWell(
                onTap: () => Routers().push(context, Routers.pageEmployee),
                child: const Center(
                  child: Text("欢迎使用", style: TextStyle(fontSize: 24)),
                ),
              ),
            );
          })),
    );
  }
}
