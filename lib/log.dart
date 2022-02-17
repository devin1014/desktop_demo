import 'package:logger/logger.dart';

abstract class ILog {
  factory ILog.get(String tag) => _Log().get(tag);

  void v(String message);

  void d(String message);

  void i(String message);

  void w(String message);

  void e(String message);
}

class _Log {
  static late final _Log _instance = _Log._();

  factory _Log() => _instance;

  _Log._();

  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

  ILog get(String tag) => _LogWrapper(logger, tag);
}

class _LogWrapper implements ILog {
  _LogWrapper(this.logger, this.tag);

  final Logger logger;
  final String tag;

  @override
  void d(String message) => logger.d("$tag: $message");

  @override
  void e(String message) => logger.e("$tag: $message");

  @override
  void i(String message) => logger.i("$tag: $message");

  @override
  void v(String message) => logger.v("$tag: $message");

  @override
  void w(String message) => logger.w("$tag: $message");
}
