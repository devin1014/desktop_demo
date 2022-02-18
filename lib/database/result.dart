import 'package:desktop_demo/log.dart';
import 'package:flutter/foundation.dart';

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
