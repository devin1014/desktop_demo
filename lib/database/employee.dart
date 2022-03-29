// ignore_for_file: constant_identifier_names

import 'package:desktop_demo/database/message.dart';
import 'package:desktop_demo/database/log.dart';

abstract class DbModel {
  final Map<String, String> _data = {};
  final List<String> _errKeys = [];

  DbModel.fromJson(Map<String, dynamic>? json) {
    json?.forEach((key, value) {
      set(key, value.toString());
    });
  }

  void set(String key, String value) {
    _data[key] = value;
    if (validFieldValue(key, value)) {
      _errKeys.remove(key);
    } else {
      _errKeys.add(key);
    }
  }

  bool validFieldValue(String key, String value);

  String get(String key) => _data[key] ?? "";

  List<String> getValues(List<String> keys) {
    List<String> values = [];
    for (var e in keys) {
      values.add(get(e));
    }
    return values;
  }

  Map<String, dynamic> toMap() => _data;

  List<String> get invalidFields => _errKeys;

  bool isInvalidField(String name) => _errKeys.contains(name);

  bool get hasInvalidField => _errKeys.isNotEmpty;

  String get uniqueId;

  @override
  int get hashCode => uniqueId.hashCode;

  @override
  bool operator ==(dynamic other) => (other is DbModel) && uniqueId == other.uniqueId;

  @override
  String toString() => "\n${_data.toString()}";
}

mixin IEmployee on DbModel {
  static const column_name = "姓名";
  static const column_identifyType = "证件类型";
  static const column_identifyId = "证件号码";
  static const column_gender = "性别";
  static const column_phone = "手机";
  static const column_type = "类型";
  static const column_social = "社保";
  static const column_company = "公司";
  static const column_departments = "部门";
  static const column_unionName = "工会";
  static const column_note = "备注";

  static const List<String> columns = [
    column_name,
    column_identifyType,
    column_identifyId,
    column_gender,
    column_phone,
    column_type,
    column_social,
    column_company,
    column_departments,
    column_unionName,
    column_note
  ];

  static const value_identify_types = ["身份证"];
  static const value_genders = ["男", "女"];
  static const value_yes_or_no = ["是", "否"];
  static const value_work_types = ["正式", "劳务派遣", "借调", "退休返聘", "实习", "其他"];
  static const value_companion = [
    "城建置业",
    "益恒置业",
    "益欣置业",
    "瑞恒置业",
    "瑞腾国际",
    "博远置业",
    "瑞南置业",
    "丰鑫置业",
    "黄山合城",
    "宝盛",
    "建房处",
    "后勤保障",
    "城建物业",
    "瑞行东岸",
    "无锡公司",
    "蠡湖公司",
    "江西公司"
  ];
  static const _format_phone_length = 11;
  static const _format_identify_id_length = 18;

  static final _logger = ILog.get("IEmployee");

  @override
  bool validFieldValue(String key, String value) {
    bool contains(List<dynamic> list, dynamic value) {
      if (list.contains(value)) return true;
      _logger.w("${Message.setValueError}, $key:$value, ${Message.setValueList}:${list.toString()}");
      return false;
    }

    bool checkLength(dynamic value, int exceptValue) {
      if (value.toString().length == exceptValue) return true;
      _logger.w("${Message.setValueError}, $key:$value, ${Message.setValueLength}:$exceptValue");
      return false;
    }

    if (key == column_gender && !contains(value_genders, value)) {
      return false;
    } else if (key == column_social && !contains(value_yes_or_no, value)) {
      return false;
    } else if (key == column_type && !contains(value_work_types, value)) {
      return false;
    } else if (key == column_phone && !checkLength(value, _format_phone_length)) {
      return false;
    } else if (key == column_identifyId && !checkLength(value, _format_identify_id_length)) {
      return false;
    }
    return true;
  }
}

class Employee extends DbModel with IEmployee {
  Employee.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  Employee.fromValues(List<String> values) : super.fromJson({}) {
    if (IEmployee.columns.length != values.length) {
      throw Exception("values length not match columns: ${IEmployee.columns.toString()}");
    }
    for (var i = 0; i < IEmployee.columns.length; i++) {
      set(IEmployee.columns[i], values[i]);
    }
  }

  Employee.build(
    String name,
    String identifyType,
    String identifyId,
    String gender,
    String phone,
    String type,
    String hasSocialSecurity,
    String company,
    String departments,
    String unionName,
    String note,
  ) : this.fromValues([
          name,
          identifyType,
          identifyId,
          gender,
          phone,
          type,
          hasSocialSecurity,
          company,
          departments,
          unionName,
          note
        ]);

  @override
  String get uniqueId => "${get(IEmployee.column_name)}@${get(IEmployee.column_phone)}";
}
