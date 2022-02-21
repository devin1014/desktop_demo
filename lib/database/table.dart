// ignore_for_file: avoid_print

import 'package:desktop_demo/database/employee.dart';
import 'package:flutter/material.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({Key? key, required this.list}) : super(key: key);

  final List<Employee> list;

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  final ValueNotifier<int> _valueNotifier = ValueNotifier(-1);

  int _lastSelected = -1;

  int _getFlex(String name) {
    if (name == IEmployee.column_identifyId || name == IEmployee.column_phone) {
      return 5;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    print("${runtimeType.toString()} build");
    return Column(
      children: [
        /// title
        _RowItem(
          tag: "title row",
          height: 30,
          bgColor: Colors.grey,
          items: IEmployee.columns,
          flexBuilder: _getFlex,
          widgetBuilder: (context, name) =>
              Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
        Expanded(
          /// real data
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final Employee employee = widget.list[index];
                return InkWell(
                  onHover: (changed) {
                    if (changed) {
                      //_valueNotifier.value = index;
                    }
                  },
                  onTap: () {
                    if (_valueNotifier.value != index) {
                      _lastSelected = _valueNotifier.value;
                    }
                    _valueNotifier.value = index;
                    print("tap: current=$index, last=$_lastSelected");
                  },
                  onDoubleTap: () {
                    //TODO
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _valueNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      //TODO: check child cache
                      //print("ValueListenableBuilder: $value 0x${child?.hashCode.toRadixString(16)}");
                      final selected = value == index;
                      if (_lastSelected != index && !selected && child != null) {
                        return child;
                      }
                      return _RowItem(
                          tag: "$index:${employee.get(IEmployee.column_name)}:$selected:$_lastSelected",
                          height: 30,
                          bgColor: selected ? Colors.lightBlue : null,
                          items: IEmployee.columns,
                          flexBuilder: _getFlex,
                          widgetBuilder: (context, name) {
                            return Container(
                                alignment: Alignment.center,
                                color: employee.isInvalidField(name) ? Colors.yellow : null,
                                child: Text(
                                  employee.get(name),
                                  style: TextStyle(color: employee.isInvalidField(name) ? Colors.red : Colors.black),
                                ));
                          });
                    },
                    child: _RowItem(
                        tag: "$index:${employee.get(IEmployee.column_name)}",
                        height: 30,
                        items: IEmployee.columns,
                        flexBuilder: _getFlex,
                        widgetBuilder: (context, name) {
                          return Container(
                              alignment: Alignment.center,
                              color: employee.isInvalidField(name) ? Colors.yellow : null,
                              child: Text(
                                employee.get(name),
                                style: TextStyle(color: employee.isInvalidField(name) ? Colors.red : Colors.black),
                              ));
                        }),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1.0, color: Colors.grey),
              itemCount: widget.list.length),
        )
      ],
    );
  }
}

typedef ItemFlexBuilder = int Function(String item);
typedef ItemWidgetBuilder = Widget Function(BuildContext context, String item);

/// row item
class _RowItem extends StatelessWidget {
  const _RowItem({
    Key? key,
    this.tag,
    this.width,
    this.height,
    this.bgColor,
    required this.items,
    required this.flexBuilder,
    required this.widgetBuilder,
  }) : super(key: key);

  final String? tag;
  final double? width;
  final double? height;
  final Color? bgColor;
  final List<String> items;
  final ItemFlexBuilder flexBuilder;
  final ItemWidgetBuilder widgetBuilder;

  @override
  Widget build(BuildContext context) {
    print("${runtimeType.toString()}(0x${hashCode.toRadixString(16)}) build, tag=$tag");
    return Container(
      width: width ?? double.infinity,
      height: height,
      color: bgColor,
      child: Row(children: items.map((e) => buildItem(context, e)).toList(growable: false)),
    );
  }

  Widget buildItem(BuildContext context, String value) =>
      Expanded(flex: flexBuilder(value), child: widgetBuilder(context, value));
}
