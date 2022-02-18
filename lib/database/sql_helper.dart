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
}
