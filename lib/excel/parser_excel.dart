// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ParserExcelDemo extends StatefulWidget {
  const ParserExcelDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParserExcelDemoState();
}

class _ParserExcelDemoState extends State<ParserExcelDemo> {
  final Future<SharedPreferences> _shredPreference = SharedPreferences.getInstance();
  final ValueNotifier<String> _valueNotifier = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    Future.sync(() async {
      final path = (await _shredPreference).getString("path") ?? "";
      _valueNotifier.value = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("解析Excel")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, String value, child) {
                return Text(value, style: const TextStyle(color: Colors.black, fontSize: 16));
              },
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _parseExcel, child: const Text("选择excel文件", style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  void _parseExcel() async {
    final excelFile = await FilePicker.platform.pickFiles(dialogTitle: "请选择Excel文件");
    if (excelFile == null || excelFile.files.isEmpty) return;
    final path = excelFile.files.first.path!;
    _valueNotifier.value = path;
    (await _shredPreference).setString("excelPath", path);
    final bytes = File(path).readAsBytesSync();
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for (var table in decoder.tables.keys) {
      _printSheet(decoder.tables[table]!);
    }
  }

  void _printSheet(SpreadsheetTable table) {
    print("table:${table.name}, maxCols:${table.maxCols}, maxRows:${table.maxRows}");
    for (var row in table.rows) {
      print('$row');
    }
  }
}
