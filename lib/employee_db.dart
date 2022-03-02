import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/result.dart';
import 'package:desktop_demo/database/search.dart';
import 'package:desktop_demo/database/table.dart';
import 'package:desktop_demo/dialog.dart';
import 'package:desktop_demo/routers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EmployeeDatabase extends StatefulWidget {
  const EmployeeDatabase({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmployeeDatabaseState();
}

class _EmployeeDatabaseState extends State<EmployeeDatabase> {
  final DatabaseProvider _provider = DatabaseProvider();
  final ValueNotifier<List<Employee>> _valueNotifier = ValueNotifier(<Employee>[]);
  final GlobalKey<EmployeeTableState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.sync(() async {
      final result = (await _provider.query()).data!;
      _valueNotifier.value = result;
      // if (result.isEmpty) {
      //   /// test code! when database is empty, insert data
      //   for (var element in sampleEmployeeList) {
      //     _provider.insert(element);
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text("人员信息库"),
        actions: [_buildToolbarAction(context)],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 32,
            child: Row(
              children: [
                //TODO
              ],
            ),
          ),
          // const Divider(height: 1.0, color: Colors.grey),
          Expanded(
            child: ValueListenableBuilder<List<Employee>>(
              valueListenable: _valueNotifier,
              builder: (context, value, child) => EmployeeTable(
                key: _globalKey,
                list: value,
                callback: (employee) async {
                  final result = await DialogUtil.showListSimpleDialog(context, title: "选择", list: ["更新", "删除"]);
                  if (result == 0) {
                    // _update(employee);
                    _insert(pageContext, employee: employee);
                  } else if (result == 1) {
                    _delete(employee);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _actionAddEmployee = 1;
  static const _actionSearchEmployee = 2;
  static const _importExcelFile = 3;

  Widget _buildToolbarAction(BuildContext pageContext) => PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(child: Text("添加"), value: _actionAddEmployee),
            const PopupMenuItem(child: Text("查找"), value: _actionSearchEmployee),
            const PopupMenuItem(child: Text("倒入Excel文件"), value: _importExcelFile),
          ];
        },
        onSelected: (value) async {
          if (value == _actionAddEmployee) {
            _insert(pageContext);
          } else if (value == _actionSearchEmployee) {
            DialogUtil.showCustomDialog(pageContext, const SearchEmployee()).then((result) {
              if (result is Map) {
                final key = result.keys.first;
                final value = result.values.first;
                bool find = false;
                int index = 0;
                for (var employee in _valueNotifier.value) {
                  if (employee.get(key) == value) {
                    find = true;
                    break;
                  }
                  index++;
                }
                if (find) {
                  _globalKey.currentState?.selected = index;
                } else {
                  ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(content: Text("没有找到，$key:$value")));
                }
              }
            });
          } else if (value == _importExcelFile) {
            final excelFile = await FilePicker.platform.pickFiles(dialogTitle: "请选择Excel文件");
            if (excelFile == null || excelFile.files.isEmpty) return;
            final path = excelFile.files.first.path!;
            // final bytes = File(path).readAsBytesSync();
            // final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
            // for (var table in decoder.tables.keys) {
            // }
          }
        },
        iconSize: 32,
        onCanceled: () {},
      );

  void _insert(BuildContext pageContext, {Employee? employee}) {
    Routers().push(
      pageContext,
      Routers.pageInsert,
      arguments: {"employee": employee},
    ).then((value) async {
      if (value is Result) {
        if (value.code == ResultCode.success) {
          _valueNotifier.value = (await _provider.query()).data!;
        } else {
          ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(content: Text(value.message)));
        }
      }
    });
  }

  void _delete(Employee employee) async {
    final result = await _provider.delete(employee);
    if (result.code == ResultCode.success) {
      _valueNotifier.value = (await _provider.query()).data!;
    }
  }

// void _update(Employee employee) async {
// employee.set(IEmployee.column_note, "#${Random(DateTime.now().millisecondsSinceEpoch).nextInt(100)}");
// final result = await _provider.update(employee);
// if (result.code == ResultCode.success) {
//   _valueNotifier.value = await _query();
// }
// }
//
// void _refresh() async {
//   _valueNotifier.value = await _query();
// }
//
// Future<List<Employee>> _query() async => (await _provider.query()).data!;
}
