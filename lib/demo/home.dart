// ignore_for_file: avoid_print

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'job.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> items = [];
  List<DropdownMenuItem<String>> menuItems = [];
  String selectItem = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: _parseJobInfo,
            child: const Text("获取Job相关文件"),
          ),
          TextButton(
            onPressed: () => _dataDir = null,
            child: const Text("clear"),
          ),
          buildDropdownContent(),
        ],
      ),
    );
  }

  Widget buildDropdownContent() {
    if (items.isEmpty) return const Text("请先解析Jobs文件");
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: menuItems,
        value: selectItem,
        // selectedItemBuilder: (context) {
        //   return items.map((e) => Text(e)).toList();
        // },
        onChanged: (value) {
          setState(() {
            selectItem = value!;
          });
        },
      ),
    );
  }

  String? _dataDir;

  ///Volumes/Macintosh HD/Users/liuwei/Desktop/data/jobsancestry.txt
  void _parseJobInfo() async {
    items.clear();
    _dataDir ??= await FilePicker.platform.getDirectoryPath(dialogTitle: "请选择data文件夹");
    if (_dataDir == null) return;
    try {
      print("开始解析jobsancestry.txt");
      List<String> jobsancestry = await getFile(_dataDir!, "jobsancestry.txt").readAsLines();
      for (var data in jobsancestry) {
        if (data.startsWith("#")) continue;
        JobAncestry result = JobAncestry.builder(data);
        print(result);
        items.add(result.name);
      }
      menuItems = items.map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(e, style: const TextStyle(fontSize: 18)),
        );
      }).toList();
      selectItem = items.first;
      print("menuItems: ${menuItems.length}");
      print("selectItem: $selectItem");
      // print("开始解析jobs.txt");
      // for (var data in await getFile(_dataDir!, "jobs.txt").readAsLines()) {
      //   if (data.startsWith("#")) continue;
      //   print(Job.builder(data));
      // }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  File getFile(String dir, String name) => File("$dir${Platform.pathSeparator}$name");
}
