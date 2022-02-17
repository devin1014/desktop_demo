// ignore_for_file: avoid_print

import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/result.dart';
import 'package:desktop_demo/log.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static late final DatabaseProvider _provider = DatabaseProvider._();

  factory DatabaseProvider() => _provider;

  DatabaseProvider._() {
    sqfliteFfiInit();
    _databaseFuture = _initDatabase();
  }

  final String _dbFileName = "my_db.db";
  final String _table = "Employee";
  final int _version = 1;
  final ILog logger = ILog.get("DatabaseProvider");
  late final Future<Database> _databaseFuture;

  Future<Database> _initDatabase() async {
    logger.d(Message.initDatabase);
    final path = join(await databaseFactoryFfi.getDatabasesPath(), _dbFileName);
    final database = await databaseFactoryFfi.openDatabase(path, options: _options);
    logger.d("${Message.initDatabase} ${Message.success}");
    return database;
  }

  String get _tableName => "$_table$_version";

  OpenDatabaseOptions get _options => OpenDatabaseOptions(
        version: _version,
        onCreate: (database, version) async {
          logger.i("create 'database', version:$version");
          await database.execute(_createTableSql(_tableName));
        },
        onUpgrade: (database, oldVersion, newVersion) async {
          logger.i("upgrade 'database', oldVersion:$oldVersion, newVersion:$newVersion");
          await database.execute(_deleteTableSql("$_table$oldVersion"));
          await database.execute(_createTableSql(_tableName));
        },
        onDowngrade: (database, oldVersion, newVersion) async {
          logger.w("downgrade 'database', oldVersion:$oldVersion, newVersion:$newVersion");
        },
      );

  String _createTableSql(String table) => "CREATE TABLE $table (${Employee.sqlBuildTableColumns})";

  String _deleteTableSql(String table) => "DROP TABLE $table";

  Future<Result<void>> insert(Employee employee) {
    return _databaseFuture.then((database) async {
      if (await _container(database, employee)) {
        return Result.failed(message: Message.addFailedAlreadyExisted);
      }

      final rowId = await database.insert(
        _tableName,
        employee.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (rowId > 0) {
        return Result.success(message: "${Message.addSuccess}: ${employee.uniqueId}");
      } else {
        return Result.failed(message: "${Message.addFailed}: ${employee.uniqueId}");
      }
    }).catchError((onError) {
      return Result.error(message: "${Message.error}: $onError");
    });
  }

  Future<bool> _container(Database database, Employee employee) async {
    List<Map<String, dynamic>> list =
        await database.query(_tableName, where: Employee.sqlWhereUniqueId, whereArgs: [employee.uniqueId]);
    return list.isNotEmpty;
  }

  Future<Result<void>> delete(Employee employee) {
    return _databaseFuture.then((database) async {
      int rowId = await database.delete(
        _tableName,
        where: Employee.sqlWhereUniqueId,
        whereArgs: [employee.uniqueId],
      );
      if (rowId > 0) {
        return Result.success(message: "${Message.deleteSuccess}: ${employee.uniqueId}");
      } else {
        return Result.failed(message: "${Message.deleteFailed}: ${employee.uniqueId}");
      }
    }).catchError((onError) {
      return Result.error(message: "${Message.error}: $onError");
    });
  }

  Future<Result<void>> update(Employee employee) {
    return _databaseFuture.then((database) async {
      final rowId = await database.update(
        _tableName,
        employee.toMap(),
        where: Employee.sqlWhereUniqueId,
        whereArgs: [employee.uniqueId],
      );
      if (rowId > 0) {
        return Result.success(message: "${Message.updateSuccess}: ${employee.uniqueId}");
      } else {
        return Result.failed(message: "${Message.updateFailed}: ${employee.uniqueId}");
      }
    }).catchError((onError) {
      return Result.error(message: "${Message.error}: $onError");
    });
  }

  Future<Result<List<Employee>>> query() {
    return _databaseFuture.then((database) async {
      List<Map<String, dynamic>> result = await database.query(_tableName);
      final list = result.map((e) => Employee.fromJson(e)).toList();
      if (list.isNotEmpty) {
        return Result.success(data: list, message: Message.querySuccess);
      } else {
        return Result.failed(data: List<Employee>.empty(), message: Message.queryFailedEmptyData);
      }
    }).catchError((onError) {
      return Result.error(data: List<Employee>.empty(), message: "${Message.error}: $onError");
    });
  }
}
