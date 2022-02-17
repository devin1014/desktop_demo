import 'dart:math';

import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/sample_data.dart';
import 'package:desktop_demo/database/table.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DatabaseDemo extends StatefulWidget {
  const DatabaseDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatabaseDemoState();
}

class _DatabaseDemoState extends State<DatabaseDemo> {
  final DatabaseProvider _provider = DatabaseProvider();
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));
  final ValueNotifier<List<Employee>> _valueNotifier = ValueNotifier(<Employee>[]);

  @override
  void initState() {
    super.initState();
    Future.sync(() async {
      final employeeSize = (await _provider.query()).data!.length;
      if (employeeSize == 0) {
        for (var element in sampleEmployeeList) {
          _provider.insert(element);
        }
      }
    });
  }

  List<String> _filterNames = [];

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
            Row(
              children: [
                TextButton(onPressed: _add, child: const Text("添加人员", style: TextStyle(fontSize: 14))),
                const SizedBox(height: 16),
                TextButton(onPressed: _delete, child: const Text("删除人员", style: TextStyle(fontSize: 14))),
                const SizedBox(height: 16),
                TextButton(onPressed: _update, child: const Text("更新人员", style: TextStyle(fontSize: 14))),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () async {
                      _valueNotifier.value = await _query();
                      _filterNames = _valueNotifier.value.map((e) => e.name).toList(growable: false);
                    },
                    child: const Text("查询人员", style: TextStyle(fontSize: 14))),
              ],
            ),
            const Divider(height: 1.0, color: Colors.grey),
            SizedBox(
              height: 54,
              child: DropdownButton<String>(
                value: "",
                icon: const Icon(Icons.arrow_drop_down_sharp),
                onChanged: (newValue) {},
                items: _filterNames
                    .map<DropdownMenuItem<String>>((value) => DropdownMenuItem(child: Text(value)))
                    .toList(),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Employee>>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) => EmployeeTable(list: value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Employee get _employee =>
      Employee("测试", "身份证", "666", "男", "123456789", "正式", "2000-01-01", "否", "否", "公司", "部门", "工会", "备注");

  void _add() async => await _provider.insert(_employee);

  void _delete() async => await _provider.delete(_employee);

  void _update() async {
    Employee employee = _employee;
    employee.description = "description_${Random(DateTime.now().millisecondsSinceEpoch).nextInt(100)}";
    await _provider.update(employee);
  }

  Future<List<Employee>> _query() async => (await _provider.query()).data!;
}
