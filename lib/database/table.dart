import 'package:desktop_demo/database/employee.dart';
import 'package:flutter/material.dart';

class EmployeeTable extends StatelessWidget {
  const EmployeeTable({Key? key, required this.list}) : super(key: key);

  final List<Employee> list;

  int _getFlex(String name) {
    if (name == IEmployee.column_identifyId || name == IEmployee.column_phone) {
      return 5;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// title
        RowItem(
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
                return InkWell(
                  onDoubleTap: () {},
                  child: RowItem(
                      height: 30,
                      items: IEmployee.columns,
                      flexBuilder: _getFlex,
                      widgetBuilder: (context, name) => Center(child: Text(list[index].get(name)))),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1.0, color: Colors.grey),
              itemCount: list.length),
        )
      ],
    );
  }
}

typedef ItemFlexBuilder = int Function(String item);
typedef ItemWidgetBuilder = Widget Function(BuildContext context, String item);

/// row item
class RowItem extends StatelessWidget {
  const RowItem({
    Key? key,
    this.width,
    this.height,
    this.bgColor,
    required this.items,
    required this.flexBuilder,
    required this.widgetBuilder,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? bgColor;
  final List<String> items;
  final ItemFlexBuilder flexBuilder;
  final ItemWidgetBuilder widgetBuilder;

  @override
  Widget build(BuildContext context) {
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
