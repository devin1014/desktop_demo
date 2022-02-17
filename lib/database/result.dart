import 'package:desktop_demo/log.dart';
import 'package:flutter/foundation.dart';

class Message {
  static const String database = "数据库";

  static const String initDatabase = "初始化数据库";

  static const String success = "成功";
  static const String failed = "失败";
  static const String error = "错误";
  static const String addSuccess = "添加成功";
  static const String addFailed = "添加失败";
  static const String addFailedAlreadyExisted = "添加失败（已有当前数据）";
  static const String deleteSuccess = "删除成功";
  static const String deleteFailed = "删除失败";
  static const String updateSuccess = "更新成功";
  static const String updateFailed = "更新失败";
  static const String querySuccess = "查询成功";
  static const String queryFailed = "查询失败";
  static const String queryFailedEmptyData = "查询失败（没有相关数据）";
}

class ResultCode {
  static const int success = 100;
  static const int failed = 200;
  static const int error = 300;
}

class Result<T> {
  static const bool debugMode = !kReleaseMode;

  Result(this.code, this.message, this.data, this.printLog) {
    _print();
  }

  final int code;
  final String message;
  final T? data;
  final bool printLog;

  Result.success({
    T? data,
    String message = "",
    bool printLog = debugMode,
  }) : this(ResultCode.success, message, data, printLog);

  Result.failed({
    T? data,
    String message = "",
    bool printLog = debugMode,
  }) : this(ResultCode.failed, message, data, printLog);

  Result.error({
    T? data,
    String message = "",
    bool printLog = debugMode,
  }) : this(ResultCode.error, message, data, printLog);

  void _print() {
    if (printLog) {
      final logger = ILog.get("DB Result");
      switch (code) {
        case ResultCode.success:
          logger.d(message);
          if (data != null) {
            logger.d("data: ${data.toString()}");
          }
          break;
        case ResultCode.failed:
          logger.w(message);
          if (data != null) {
            logger.w("data: ${data.toString()}");
          }
          break;
        case ResultCode.error:
          logger.e(message);
          if (data != null) {
            logger.e("data: ${data.toString()}");
          }
          break;
        default:
          logger.v(message);
          if (data != null) {
            logger.v("data: ${data.toString()}");
          }
          break;
      }
    }
  }
}
