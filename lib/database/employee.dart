// ignore_for_file: constant_identifier_names

class _EmployeeSqlHelper {
  static const column_uniqueId = "人员识别码";
  static const column_name = "姓名";
  static const column_identifyType = "证件类型";
  static const column_identifyId = "证件号码";
  static const column_male = "性别";
  static const column_mobile = "手机";
  static const column_type = "类型";
  static const column_birthDay = "生日";
  static const column_hasSocialSecurity = "缴纳社保";
  static const column_isJoinUnion = "工会成员";
  static const column_company = "公司";
  static const column_departments = "部门";
  static const column_unionName = "工会";
  static const column_description = "备注";

  static const List<String> columns = [
    column_uniqueId,
    column_name,
    column_identifyType,
    column_identifyId,
    column_male,
    column_mobile,
    column_type,
    column_birthDay,
    column_hasSocialSecurity,
    column_isJoinUnion,
    column_company,
    column_departments,
    column_unionName,
    column_description
  ];

  static String buildTableColumns() {
    StringBuffer buffer = StringBuffer("id INTEGER PRIMARY KEY");
    for (var element in columns) {
      buffer.write(",");
      buffer.write(element + " TEXT");
    }
    return buffer.toString();
  }
}

class Employee {
  static String get sqlBuildTableColumns => _EmployeeSqlHelper.buildTableColumns();

  static String get columnUniqueId => _EmployeeSqlHelper.column_uniqueId;

  static String get sqlWhereUniqueId => "$columnUniqueId = ?";

  String name;
  String identifyType;
  String identifyId;
  String male;
  String mobile;
  String type;
  String birthDay;
  String hasSocialSecurity;
  String isJoinUnion;
  String company;
  String departments;
  String unionName;
  String description;
  final Map<String, String> _data = {};

  Employee(
    this.name,
    this.identifyType,
    this.identifyId,
    this.male,
    this.mobile,
    this.type,
    this.birthDay,
    this.hasSocialSecurity,
    this.isJoinUnion,
    this.company,
    this.departments,
    this.unionName,
    this.description,
  ) {
    buildData();
  }

  Employee.fromJson(Map<String, dynamic> json)
      : name = json[_EmployeeSqlHelper.column_name] ?? "",
        identifyType = json[_EmployeeSqlHelper.column_identifyType] ?? "",
        identifyId = json[_EmployeeSqlHelper.column_identifyId] ?? "",
        male = json[_EmployeeSqlHelper.column_male] ?? "",
        mobile = json[_EmployeeSqlHelper.column_mobile] ?? "",
        type = json[_EmployeeSqlHelper.column_type] ?? "",
        birthDay = json[_EmployeeSqlHelper.column_birthDay] ?? "",
        hasSocialSecurity = json[_EmployeeSqlHelper.column_hasSocialSecurity] ?? "",
        isJoinUnion = json[_EmployeeSqlHelper.column_isJoinUnion] ?? "",
        company = json[_EmployeeSqlHelper.column_company] ?? "",
        departments = json[_EmployeeSqlHelper.column_departments] ?? "",
        unionName = json[_EmployeeSqlHelper.column_unionName] ?? "",
        description = json[_EmployeeSqlHelper.column_description] ?? "" {
    buildData();
  }

  void buildData() {
    _data[_EmployeeSqlHelper.column_uniqueId] = uniqueId;
    _data[_EmployeeSqlHelper.column_name] = name;
    _data[_EmployeeSqlHelper.column_identifyType] = identifyType;
    _data[_EmployeeSqlHelper.column_identifyId] = identifyId;
    _data[_EmployeeSqlHelper.column_male] = male;
    _data[_EmployeeSqlHelper.column_mobile] = mobile;
    _data[_EmployeeSqlHelper.column_type] = type;
    _data[_EmployeeSqlHelper.column_birthDay] = birthDay;
    _data[_EmployeeSqlHelper.column_hasSocialSecurity] = hasSocialSecurity;
    _data[_EmployeeSqlHelper.column_isJoinUnion] = isJoinUnion;
    _data[_EmployeeSqlHelper.column_company] = company;
    _data[_EmployeeSqlHelper.column_departments] = departments;
    _data[_EmployeeSqlHelper.column_unionName] = unionName;
    _data[_EmployeeSqlHelper.column_description] = description;
  }

  Map<String, dynamic> toMap() => _data;

  /// unique id for every employee.
  String get uniqueId => "$name@$mobile@$identifyId";

  @override
  int get hashCode => uniqueId.hashCode;

  @override
  bool operator ==(other) {
    if (other is! Employee) {
      return false;
    }
    return name == other.name && (identifyId == other.identifyId || mobile == other.mobile);
  }

  @override
  String toString() => _data.toString();
}
