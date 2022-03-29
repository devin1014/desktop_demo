import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  static const _defaultSelect = "无";
  final String title;
  final List<String> items = [];
  final ValueChanged<String?> valueChanged;

  Filter({
    Key? key,
    required this.title,
    required List<String> list,
    required this.valueChanged,
  }) : super(key: key) {
    items.add(_defaultSelect);
    items.addAll(list);
  }

  @override
  State<StatefulWidget> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String select = Filter._defaultSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title),
        const SizedBox(width: 12),
        DropdownButton(
            alignment: Alignment.center,
            value: select,
            items: widget.items
                .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(child: Text(e), value: e))
                .toList(growable: false),
            onChanged: (changed) {
              setState(() {
                select = changed.toString();
              });
              if (changed == Filter._defaultSelect) {
                widget.valueChanged(null);
              } else if (changed is String) {
                widget.valueChanged(changed);
              }
            }),
      ],
    );
  }
}
