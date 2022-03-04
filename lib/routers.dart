import 'package:flutter/material.dart';

class Routers {
  Routers._();

  static late final Routers _instance = Routers._();

  factory Routers() => _instance;

  static const pageEmployee = "pageEmployee";
  static const pageInsert = "pageInsert";
  static const pageUpdate = "pageUpdate";
  static const pageSearch = "pageSearch";
  static const pageImport = "pageImport";
  static const pageParserExcel = "pageParserExcel";

  static const pageDropdownButton = "pageDropdownButton";
  static const pageDropdownMenu = "pageDropdownMenu";
  static const pageTextField = "pageTextField";

  final Map<String, Widget> _routerMap = {};

  Widget _notFoundPageBuilder(BuildContext context, String page) => const _NotFoundPage();

  void register(String page, Widget widget) {
    _routerMap[page] = widget;
  }

  Future<dynamic> push(BuildContext context, String page, {Map<String, dynamic>? arguments}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _routerMap[page] ?? _notFoundPageBuilder(context, page),
        settings: RouteSettings(name: "argument", arguments: arguments),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NotFount")),
      body: const Center(child: Text("404")),
    );
  }
}
