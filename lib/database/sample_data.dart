import 'package:desktop_demo/database/employee.dart';

Employee employee1 =
    Employee.build("赵一", "身份证", "310100200010100001", "男", "00123456789", "正式", "否", "集团", "人事部", "工会1", "11");
Employee employee2 =
    Employee.build("钱二", "身份证", "310100200010100002", "女", "01123456789", "正式", "是", "集团", "人事部", "工会1", "");
Employee employee3 =
    Employee.build("孙三", "身份证", "310100200010100003", "男", "02123456789", "劳务派遣", "否", "集团", "人事部", "工会1", "22");
Employee employee4 =
    Employee.build("李四", "身份证", "310100200010100004", "女", "03123456789", "劳务派遣", "是", "集团", "营销部", "工会2", "");
Employee employee5 =
    Employee.build("王五", "身份证", "310100200010100005", "男", "04123456789", "退休返聘", "否", "集团", "营销部", "工会2", "33");
Employee employee6 =
    Employee.build("赵六", "身份证", "310100200010100007", "男", "05123456789", "正式", "否", "隧道", "工程一部", "工会3", "");
Employee employee7 =
    Employee.build("钱七", "身份证", "310100200010100007", "女", "06123456789", "正式", "是", "隧道", "工程一部", "工会3", "44");
Employee employee8 =
    Employee.build("孙八", "身份证", "310100200010100008", "女", "07123456789", "正式", "否", "隧道", "工程二部", "工会3", "");
Employee employee9 =
    Employee.build("李九", "身份证", "310100200010100009", "男", "08123456789", "正式", "是", "隧道", "工程二部", "工会3", "55");
Employee employee10 =
    Employee.build("王十", "身份证", "310100200010100010", "男", "09123456789", "正式", "否", "隧道", "工程三部", "工会3", "");

List<Employee> sampleEmployeeList = [
  employee1,
  employee2,
  employee3,
  employee4,
  employee5,
  employee6,
  employee7,
  employee8,
  employee9,
  employee10,
];

Employee get testEmployee =>
    Employee.fromValues(["测试-老王", "身份证", "31010020001010xxxx", "男", "x0123456789", "正式", "否", "公司", "部门", "工会", "备注"]);

Employee get testErrorEmployee =>
    Employee.fromValues(["测试-小王", "身份证", "666?", "-", "777", "不知道", "-", "公司", "部门", "工会", "备注"]);
