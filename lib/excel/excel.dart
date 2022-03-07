// ignore_for_file: avoid_print

import 'dart:io';

import 'package:desktop_demo/database/employee.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelUtil {
  ExcelUtil._();

  static void createExcel(String? path, List<Employee> employees) async {
    if (path == null || path.isEmpty) return;
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    int row = 1;
    // add title
    sheet.importList(IEmployee.columns, row++, 1, false);
    // add data
    for (var e in employees) {
      sheet.importList(e.getValues(IEmployee.columns), row++, 1, false);
    }
    for (var column = 1; column <= IEmployee.columns.length; column++) {
      sheet.autoFitColumn(column);
    }
    final List<int> bytes = workbook.saveAsStream();
    await File(path).writeAsBytes(bytes);
    workbook.dispose();
  }

  static void clearExcel(SpreadsheetDecoder decoder) {
    for (var table in decoder.tables.values) {
      clearTable(decoder, table.name);
    }
  }

  static void clearTable(SpreadsheetDecoder decoder, String sheet) {
    final maxRows = decoder.tables[sheet]?.maxRows ?? -1;
    final maxCols = decoder.tables[sheet]?.maxCols ?? -1;
    print("clearTable: [$sheet], maxRows=$maxRows, maxCols=$maxCols");
    if (maxRows < 0 || maxCols < 0) return;
    while (decoder.tables[sheet]!.maxRows > 0) {
      decoder.removeRow(sheet, 0);
    }
  }

  static void addRow(SpreadsheetDecoder decoder, String sheet, List<dynamic> columns) {
    final table = decoder.tables[sheet]!;
    decoder.insertRow(sheet, table.maxRows);
    if (table.maxCols < columns.length) {
      while (table.maxCols < columns.length) {
        decoder.insertColumn(sheet, table.maxCols);
      }
    }
    for (var columnIndex = 0; columnIndex < columns.length && columnIndex < table.maxCols; columnIndex++) {
      decoder.updateCell(sheet, columnIndex, table.maxRows - 1, columns[columnIndex]);
    }
  }

  static void printExcel(SpreadsheetDecoder decoder) {
    for (var table in decoder.tables.values) {
      printTable(table);
    }
  }

  static void printTable(SpreadsheetTable table) {
    print("[${table.name}], maxCols:${table.maxCols}, maxRows:${table.maxRows} ----------------------");
    for (var row in table.rows) {
      print('$row');
    }
  }
}
