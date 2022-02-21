import 'dart:math';

import 'package:desktop_demo/database/action_dialog.dart';
import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/result.dart';
import 'package:desktop_demo/database/sample_data.dart';
import 'package:desktop_demo/database/table.dart';
import 'package:flutter/material.dart';

class DatabaseDemo extends StatefulWidget {
  const DatabaseDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatabaseDemoState();
}

class _DatabaseDemoState extends State<DatabaseDemo> {
  final DatabaseProvider _provider = DatabaseProvider();
  final ValueNotifier<List<Employee>> _valueNotifier = ValueNotifier(<Employee>[]);

  @override
  void initState() {
    super.initState();
    Future.sync(() async {
      final result = (await _provider.query()).data!;
      _valueNotifier.value = result;
      if (result.isEmpty) {
        /// test code! when database is empty, insert data
        for (var element in sampleEmployeeList) {
          _provider.insert(element);
        }
      }
    });
  }

  int _addEmployeeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DB Demo")),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        if (_addEmployeeIndex % 2 == 0) {
                          _add(testEmployee);
                        } else {
                          _add(testErrorEmployee);
                        }
                        _addEmployeeIndex++;
                      },
                      child: const Text("添加人员", style: TextStyle(fontSize: 14))),
                  // TextButton(
                  //     onPressed: () => _delete(testEmployee),
                  //     child: const Text("删除人员", style: TextStyle(fontSize: 14))),
                  // TextButton(
                  //     onPressed: () => _update(testEmployee),
                  //     child: const Text("更新人员", style: TextStyle(fontSize: 14))),
                  // TextButton(
                  //     onPressed: () async => _valueNotifier.value = await _query(),
                  //     child: const Text("查询人员", style: TextStyle(fontSize: 14))),
                ],
              ),
            ),
            const Divider(height: 1.0, color: Colors.grey),
            Expanded(
              child: ValueListenableBuilder<List<Employee>>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) => EmployeeTable(
                  list: value,
                  callback: (employee) async {
                    final result = await DialogUtil.showListSimpleDialog(context, title: "选择", list: ["更新", "删除"]);
                    if (result == 0) {
                      _update(employee);
                    } else if (result == 1) {
                      _delete(employee);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _add(Employee employee) async {
    final result = await _provider.insert(employee);
    if (result.code == ResultCode.success) {
      _valueNotifier.value = await _query();
    }
  }

  void _delete(Employee employee) async {
    final result = await _provider.delete(employee);
    if (result.code == ResultCode.success) {
      _valueNotifier.value = await _query();
    }
  }

  void _update(Employee employee) async {
    employee.set(IEmployee.column_note, "#${Random(DateTime.now().millisecondsSinceEpoch).nextInt(100)}");
    final result = await _provider.update(employee);
    if (result.code == ResultCode.success) {
      _valueNotifier.value = await _query();
    }
  }

  Future<List<Employee>> _query() async => (await _provider.query()).data!;
}
