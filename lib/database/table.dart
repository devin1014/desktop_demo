import 'package:desktop_demo/database/employee.dart';
import 'package:flutter/material.dart';

class EmployeeTable extends StatelessWidget {
  const EmployeeTable({Key? key, required this.list}) : super(key: key);

  final List<Employee> list;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return SizedBox(
              height: 48,
              child: Center(
                child: Text(
                  list[index].uniqueId,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ));
        },
        separatorBuilder: (context, index) => const Divider(height: 1.0, color: Colors.grey),
        itemCount: list.length);
  }
}
