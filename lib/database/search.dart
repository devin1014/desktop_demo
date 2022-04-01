import 'package:desktop_demo/database/employee.dart';
import 'package:flutter/material.dart';

class SearchEmployee extends StatefulWidget {
  const SearchEmployee({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchEmployeeState();
}

class _SearchEmployeeState extends State<SearchEmployee> {
  static const _filters = [
    IEmployee.column_name,
    IEmployee.column_identifyId,
    IEmployee.column_phone,
    IEmployee.column_company,
    IEmployee.column_department,
    IEmployee.column_union,
  ];

  final TextEditingController _editingController = TextEditingController();

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selected = IEmployee.column_name;
    return Container(
        width: 600,
        height: 400,
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return DropdownButton(
                    value: selected,
                    alignment: Alignment.center,
                    underline: const DecoratedBox(decoration: BoxDecoration()),
                    items: _filters
                        .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                              value: e,
                              alignment: Alignment.center,
                              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(e)),
                            ))
                        .toList(growable: false),
                    onChanged: (value) {
                      setState(() {
                        selected = value as String? ?? "";
                      });
                    },
                  );
                }),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "请输入具体内容"),
                    controller: _editingController,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: ElevatedButton(
                  onPressed: () {
                    final result = {};
                    result[selected] = _editingController.text.trim();
                    Navigator.of(context).pop(result);
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                      child: Text(
                        "确定",
                        style: TextStyle(fontSize: 16),
                      ))),
            )
          ],
        ));
  }
}
