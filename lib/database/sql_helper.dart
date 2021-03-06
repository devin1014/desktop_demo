import 'package:desktop_demo/database/employee.dart';

class SqlHelper {
  SqlHelper._();

  static String createTable(String name, List<String> columns) {
    StringBuffer buffer = StringBuffer("id INTEGER PRIMARY KEY");
    for (var element in columns) {
      buffer.write(",");
      buffer.write(element + " TEXT");
    }
    return "CREATE TABLE $name (${buffer.toString()})";
  }

  static String deleteTable(String name) => "DROP TABLE $name";

  static String filter(List<String> filters, {String action = " AND "}) {
    StringBuffer buffer = StringBuffer();
    for (var e in filters) {
      if (buffer.isNotEmpty) {
        buffer.write(action);
      }
      buffer.write("$e = ?");
    }
    return buffer.toString();
  }

  static List<String> values(Employee employee, List<String> filters) => employee.getValues(filters);

  static String? orderBy(List<String>? orders, bool asc) {
    if (orders == null || orders.isEmpty) return null;
    StringBuffer buffer = StringBuffer();
    buffer.writeAll(orders, ", ");
    buffer.write(" ");
    if (asc) {
      buffer.write("ASC");
    } else {
      buffer.write("DESC");
    }
    return buffer.toString();
  }

  static String? buildWhereSql(List<String?>? input) {
    final List<String>? list = _removeNullItem(input);
    if (list == null || list.isEmpty) return null;
    const and = "AND";
    StringBuffer buffer = StringBuffer();
    for (var element in list) {
      if (buffer.isNotEmpty) buffer.write(" $and ");
      buffer.write("$element = ?");
    }
    return buffer.toString();
  }

  static List<String>? buildWhereValue(List<String?>? input) {
    final List<String>? list = _removeNullItem(input);
    if (list == null || list.isEmpty) return null;
    return list;
  }

  static List<String>? _removeNullItem(List<String?>? list) {
    if (list != null && list.isNotEmpty) {
      final List<String> data = [];
      for (var element in list) {
        if (element != null) {
          data.add(element);
        }
      }
      return data;
    }
    return null;
  }
}
