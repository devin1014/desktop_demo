import 'package:desktop_demo/database/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestDropdownButtonDemo extends StatefulWidget {
  const TestDropdownButtonDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestDropdownButtonDemoState();
}

class _TestDropdownButtonDemoState extends State<TestDropdownButtonDemo> {
  final List<String> items = ["1", "2", "3"];
  String _valueSelected = "1";

  @override
  Widget build(BuildContext context) {
    print("${runtimeType.toString()} build");
    return Scaffold(
      appBar: AppBar(title: const Text("Test Widget")),
      body: Padding(
          padding: const EdgeInsets.all(6),
          child: StatefulBuilder(builder: (context, setState) {
            print("${context.runtimeType.toString()} build2");
            return SizedBox(
              child: DropdownButton<String>(
                value: _valueSelected,
                items: items
                    .map((e) => DropdownMenuItem<String>(
                        onTap: () {},
                        value: e,
                        alignment: Alignment.center,
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(e))))
                    .toList(growable: false),
                onChanged: (e) {
                  print("onChanged: $e");
                  setState(() {
                    _valueSelected = e ?? _valueSelected;
                  });
                },
              ),
            );
          })),
    );
  }
}

class TestPopupMenuButtonDemo extends StatefulWidget {
  const TestPopupMenuButtonDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPopupMenuButtonDemoState();
}

class _TestPopupMenuButtonDemoState extends State<TestPopupMenuButtonDemo> {
  final List<String> items = ["1", "2", "3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PopupMenuButton")),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            PopupMenuButton(
              itemBuilder: (context) {
                return items
                    .map<PopupMenuEntry<String>>((e) => PopupMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(growable: false);
              },
              onSelected: (String value) {
                print("selected: $value");
              },
            )
          ],
        ),
      ),
    );
  }
}

class TestTextFieldDemo extends StatefulWidget {
  const TestTextFieldDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestTextFieldDemoState();
}

class _TestTextFieldDemoState extends State<TestTextFieldDemo> {
  final TextEditingController _editingController1 = TextEditingController();
  final TextEditingController _editingController2 = TextEditingController();
  final TextEditingController _editingController3 = TextEditingController();

  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  void initState() {
    super.initState();
    _editingController1.addListener(() {
      final text = _editingController1.text.toLowerCase();
      print("text: $text");
    });
    _keyboardFocusNode.addListener(() {
      print("focus1: ${_keyboardFocusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    _editingController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("TextFieldDemo")),
        body: RawKeyboardListener(
          focusNode: _keyboardFocusNode,
          onKey: (event) {
            print("onKey: ${event.logicalKey.keyId}");
            if (event.logicalKey == LogicalKeyboardKey.tab) {
              //TODO
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                SizedBox(
                  width: 164,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: IEmployee.column_name,
                      hintText: "请输入名字",
                    ),
                    controller: _editingController1,
                    focusNode: _focusNode1,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 164,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: IEmployee.column_identifyId,
                      hintText: "请输入身份证",
                    ),
                    controller: _editingController2,
                    focusNode: _focusNode2,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 164,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: IEmployee.column_phone,
                      hintText: "请输入手机",
                    ),
                    controller: _editingController3,
                    focusNode: _focusNode3,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
