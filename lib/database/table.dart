// ignore_for_file: avoid_print

import 'package:desktop_demo/database/employee.dart';
import 'package:flutter/material.dart';

import 'message.dart';

typedef Callback = void Function(Employee employee);

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({Key? key, required this.list, required this.callback}) : super(key: key);

  final List<Employee> list;
  final Callback callback;

  @override
  State<EmployeeTable> createState() => EmployeeTableState();
}

class EmployeeTableState extends State<EmployeeTable> {
  static const _itemHeight = 36.0;
  final int defaultItemFlex = 2;
  final int defaultItemLongFlex = 5;
  final ValueNotifier<int> _valueNotifier = ValueNotifier(-1);
  final ScrollController _scrollController = ScrollController();
  final ScrollController _columnTitleController = ScrollController();

  set selected(int index) {
    _valueNotifier.value = index;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // print("offset: ${_scrollController.offset}");
      _columnTitleController.jumpTo(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _columnTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("${runtimeType.toString()} build");
    return Column(children: [
      _buildRowTitle(), // row title
      Expanded(
        child: Row(
          children: [
            _buildColumnIndex(), // column index
            Expanded(child: _buildContent()),
          ],
        ),
      )
    ]);
  }

  int _getFlex(String name) {
    if (name == IEmployee.column_identifyId || name == IEmployee.column_phone) {
      return defaultItemLongFlex;
    }
    return defaultItemFlex;
  }

  Widget _buildRowTitle() => Row(children: [
        _RowItem(
            tag: "title index row",
            width: 40,
            height: _itemHeight,
            bgColor: Colors.grey.shade50,
            items: const [Message.index],
            flexBuilder: (name) => defaultItemFlex,
            widgetBuilder: (context, name) => _titleCell(name: name)),
        Expanded(
            child: _RowItem(
                tag: "title other row",
                height: _itemHeight,
                bgColor: Colors.grey,
                items: IEmployee.columns,
                flexBuilder: _getFlex,
                widgetBuilder: (context, name) => _titleCell(name: name)))
      ]);

  Widget _buildColumnIndex() => SizedBox(
      width: 40,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        controller: _columnTitleController,
        itemBuilder: (context, index) => _titleCell(
          name: "${index + 1}",
          width: 40,
          height: _itemHeight,
          bgColor: Colors.blueGrey,
        ),
        separatorBuilder: (context, index) => const Divider(height: 1.0, color: Colors.grey),
        itemCount: widget.list.length,
      ));

  Widget _titleCell({
    required String name,
    double? width,
    double? height,
    Color? bgColor,
  }) {
    final child = Center(
      child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
    if (width != null && width > 0 && height != null && height > 0) {
      return Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        color: bgColor,
        child: child,
      );
    }
    return child;
  }

  int _lastSelected = -1;

  Widget _buildContent() => ListView.separated(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
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
            if (_valueNotifier.value != index) {
              _lastSelected = _valueNotifier.value;
            }
            _valueNotifier.value = index;
            print("tap: current=$index, last=$_lastSelected");
            widget.callback(employee);
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
                  height: _itemHeight,
                  bgColor: selected ? Colors.lightBlue : null,
                  items: IEmployee.columns,
                  flexBuilder: _getFlex,
                  widgetBuilder: (context, name) {
                    return Container(
                        alignment: Alignment.center,
                        color: employee.isInvalidField(name) ? Colors.yellow : null,
                        child: Text(
                          employee.get(name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: employee.isInvalidField(name) ? Colors.red : Colors.black),
                        ));
                  });
            },
            child: _RowItem(
                tag: "$index:${employee.get(IEmployee.column_name)}",
                height: _itemHeight,
                items: IEmployee.columns,
                flexBuilder: _getFlex,
                widgetBuilder: (context, name) {
                  return Container(
                      alignment: Alignment.center,
                      color: employee.isInvalidField(name) ? Colors.yellow : null,
                      child: Text(
                        employee.get(name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: employee.isInvalidField(name) ? Colors.red : Colors.black),
                      ));
                }),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1.0, color: Colors.grey),
      itemCount: widget.list.length);
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
    //print("${runtimeType.toString()}(0x${hashCode.toRadixString(16)}) build, tag=$tag");
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
