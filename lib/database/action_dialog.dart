import 'package:flutter/material.dart';

class DialogUtil {
  DialogUtil._();

  static Future<int?> showListSimpleDialog(
    BuildContext context, {
    String title = "",
    required List<String> list,
  }) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              children: _buildList(context, list));
        });
  }

  static List<Widget>? _buildList(BuildContext context, List<String> list) {
    List<Widget> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(_buildItem(context, list[i], i));
    }
    return result;
  }

  static Widget _buildItem(BuildContext context, String data, int index) {
    return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, index);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(data, style: const TextStyle(fontSize: 14)),
        ));
  }
}
