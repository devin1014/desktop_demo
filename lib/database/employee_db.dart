import 'package:desktop_demo/database/dialog.dart';
import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/result.dart';
import 'package:desktop_demo/database/search.dart';
import 'package:desktop_demo/database/table.dart';
import 'package:desktop_demo/excel/excel.dart';
import 'package:desktop_demo/routers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'filter.dart';

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
          SizedBox(height: 64, child: _buildFilter()),
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

  static const _actionAdd = 1;
  static const _actionSearch = 2;
  static const _actionDeleteAll = 5;
  static const _actionImportExcel = 3;
  static const _actionExportExcel = 4;

  Widget _buildToolbarAction(BuildContext pageContext) => PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(child: Text("添加"), value: _actionAdd),
            const PopupMenuItem(child: Text("查找"), value: _actionSearch),
            const PopupMenuItem(child: Text("删除所有"), value: _actionDeleteAll),
            const PopupMenuItem(child: Text("倒入Excel文件"), value: _actionImportExcel),
            const PopupMenuItem(child: Text("倒出Excel文件"), value: _actionExportExcel),
          ];
        },
        onSelected: (value) async {
          if (value == _actionAdd) {
            _insert(pageContext);
          } else if (value == _actionSearch) {
            _showSearchDialog(pageContext);
          } else if (value == _actionDeleteAll) {
            _delete(null);
          } else if (value == _actionImportExcel) {
            _importExcel(pageContext);
          } else if (value == _actionExportExcel) {
            _exportExcel();
          }
        },
        iconSize: 32,
        onCanceled: () {},
      );

  String? _filterType;
  String? _filterCompany;
  String? _filterDepartment;
  String? _filterUnion;

  Widget _buildFilter() {
    return Row(
      children: [
        const SizedBox(width: 12),
        const Text("筛选条件：", style: TextStyle(fontWeight: FontWeight.bold)),
        Filter(
          title: "类型",
          list: IEmployee.value_work_types,
          valueChanged: (changed) {
            _filterType = changed;
            _query();
          },
        ),
        VerticalDivider(width: 1, thickness: 1, indent: 12, endIndent: 12, color: Colors.grey.shade300),
        Filter(
          title: "公司",
          list: IEmployee.value_companion,
          valueChanged: (changed) {
            _filterCompany = changed;
            _query();
          },
        ),
        VerticalDivider(width: 1, thickness: 1, indent: 12, endIndent: 12, color: Colors.grey.shade300),
        Filter(
          title: "部门",
          list: IEmployee.value_department,
          valueChanged: (changed) {
            _filterDepartment = changed;
            _query();
          },
        ),
        VerticalDivider(width: 1, thickness: 1, indent: 12, endIndent: 12, color: Colors.grey.shade300),
        Filter(
          title: "工会",
          list: IEmployee.value_unions,
          valueChanged: (changed) {
            _filterUnion = changed;
            _query();
          },
        ),
      ],
    );
  }

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

  void _delete(Employee? employee) async {
    final Result<void> result;
    if (employee != null) {
      result = await _provider.delete(employee);
    } else {
      result = await _provider.deleteAll();
    }
    if (result.code == ResultCode.success) {
      _valueNotifier.value = (await _provider.query()).data!;
    }
  }

  void _showSearchDialog(BuildContext pageContext) {
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
  }

  void _importExcel(BuildContext pageContext) async {
    final excelFile = await FilePicker.platform.pickFiles(dialogTitle: "请选择Excel文件");
    if (excelFile == null || excelFile.files.isEmpty) return;
    final path = excelFile.files.first.path!;
    Routers().push(
      pageContext,
      Routers.pageImport,
      arguments: {"path": path},
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

  void _exportExcel({String fileName = "export.xlsx"}) async {
    final absPath = await FilePicker.platform.saveFile(
      dialogTitle: "请选择导出的文件夹",
      fileName: fileName,
    );
    ExcelUtil.createExcel(absPath, _valueNotifier.value);
  }

  void _query() async {
    _valueNotifier.value = (await _provider.query(
      type: _filterType,
      company: _filterCompany,
      department: _filterDepartment,
      union: _filterUnion,
    ))
        .data!;
  }
}
