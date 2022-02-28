import 'dart:math';

import 'package:desktop_demo/database/action_dialog.dart';
import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/result.dart';
import 'package:desktop_demo/database/sample_data.dart';
import 'package:desktop_demo/database/table.dart';
import 'package:desktop_demo/routers.dart';
import 'package:flutter/material.dart';

class EmployeeDatabase extends StatefulWidget {
  const EmployeeDatabase({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmployeeDatabaseState();
}

class _EmployeeDatabaseState extends State<EmployeeDatabase> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("人员信息库"),
        actions: [_buildToolbarAction(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
              child: Row(
                children: [],
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

  static const _actionAddEmployee = 1;
  static const _importExcelFile = 2;

  Widget _buildToolbarAction(BuildContext pageContext) => PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(child: Text("添加人员信息"), value: _actionAddEmployee),
            const PopupMenuItem(child: Text("倒入Excel文件"), value: _importExcelFile),
          ];
        },
        onSelected: (value) {
          if (value == _actionAddEmployee) {
            Routers().push(
              pageContext,
              Routers.pageInsert,
              arguments: {"employee": testEmployee},
            ).then((value) {
              if (value is Result) {
                if (value.code == ResultCode.success) {
                  _refresh();
                } else {
                  ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(content: Text(value.message)));
                }
              }
            });
          }
        },
        iconSize: 32,
        onCanceled: () {},
      );

  // void _add(Employee employee) async {
  //   final result = await _provider.insert(employee);
  //   if (result.code == ResultCode.success) {
  //     _valueNotifier.value = await _query();
  //   }
  // }

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

  void _refresh() async {
    _valueNotifier.value = await _query();
  }

  Future<List<Employee>> _query() async => (await _provider.query()).data!;
}
