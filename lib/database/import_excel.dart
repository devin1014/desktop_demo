import 'dart:io';

import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/result.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ImportExcel extends StatefulWidget {
  const ImportExcel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImportExcelState();
}

class _ImportExcelState extends State<ImportExcel> {
  String path = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print("argument: $argument");
    path = argument["path"];
    return Scaffold(
      appBar: AppBar(title: const Text("import")),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(
                height: 64,
                child: Center(
                  child: Text("请选择数据对应列表及范围", style: TextStyle(fontSize: 16)),
                )),
            Row(children: _buildItems()),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: _parseExcel,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Text("确定", style: TextStyle(fontSize: 16)),
                ))
          ],
        ),
      ),
    );
  }

  int _index = 1;

  List<Widget> _buildItems() =>
      IEmployee.columns.map((e) => _FilterItem(name: e, index: _index++)).toList(growable: false);

  void _parseExcel() async {
    final provider = DatabaseProvider();
    final bytes = File(path).readAsBytesSync();
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for (var _key in decoder.tables.keys) {
      SpreadsheetTable table = decoder.tables[_key]!;
      print("table:${table.name}, maxCols:${table.maxCols}, maxRows:${table.maxRows}");
      for (int row = 1; row < table.maxRows; row++) {
        print(table.rows[row]);
        final values = table.rows[row].map((e) => e?.toString() ?? "").toList(growable: false);
        await provider.insert(Employee.fromValues(values));
      }
    }
    Navigator.of(context).pop(Result.success());
  }
}

class _FilterItem extends StatefulWidget {
  final String name;
  final int index;

  const _FilterItem({Key? key, required this.name, required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterItemState();
}

class _FilterItemState extends State<_FilterItem> {
  String selected = "";

  @override
  Widget build(BuildContext context) {
    if (selected.isEmpty) {
      selected = _filters[widget.index];
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.name, style: const TextStyle(fontSize: 16)),
          StatefulBuilder(builder: (context, setState) {
            return DropdownButton(
                alignment: Alignment.center,
                value: selected,
                items: _filters
                    .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Center(child: Text(e))))
                    .toList(growable: false),
                onChanged: (value) {
                  setState(() {
                    selected = value as String;
                  });
                });
          }),
        ],
      ),
    );
  }
}

const _filters = [
  "",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
];
