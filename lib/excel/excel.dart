// ignore_for_file: avoid_print

import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ExcelUtil {
  ExcelUtil._();

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
