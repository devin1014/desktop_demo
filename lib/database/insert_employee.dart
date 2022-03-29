import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/util.dart';
import 'package:desktop_demo/database/log.dart';
import 'package:flutter/material.dart';

class InsertEmployeePage extends StatefulWidget {
  const InsertEmployeePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InsertEmployeePageState();
}

class _InsertEmployeePageState extends State<InsertEmployeePage> {
  final ILog logger = ILog.get("InsertEmployee");
  final DatabaseProvider _provider = DatabaseProvider();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final List<GlobalKey<FormFieldState>> _textFieldKeys = [];
  bool _updateEmployee = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Employee? employee;
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument != null && argument is Map<String, dynamic>) {
      final value = argument["employee"];
      if (value is Employee) {
        employee = value;
      }
    }
    _textFieldKeys.clear();
    _updateEmployee = employee != null;
    String title = _updateEmployee ? "更新人员信息" : "新增人员信息";
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: FocusScope(
          node: _focusScopeNode,
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                      height: 96,
                      child: Row(children: [
                        _buildTextField(IEmployee.column_name, "请输入名字",
                            defaultValue: employee?.get(IEmployee.column_name), validators: [_emptyValueValidator]),
                        _buildTextField(IEmployee.column_identifyType, "请输入证件类型",
                            defaultValue: employee?.get(IEmployee.column_identifyType),
                            validators: [_emptyValueValidator]),
                        _buildTextField(IEmployee.column_identifyId, "请输入证件号码",
                            defaultValue: employee?.get(IEmployee.column_identifyId),
                            validators: [_identifyIdValidator]),
                        _buildTextField(IEmployee.column_gender, "男/女",
                            defaultValue: employee?.get(IEmployee.column_gender), validators: [_emptyValueValidator]),
                        _buildTextField(IEmployee.column_phone, "请输入11位手机号码",
                            defaultValue: employee?.get(IEmployee.column_phone),
                            type: TextInputType.phone,
                            validators: [_phoneValidator]),
                      ])),
                  SizedBox(
                    height: 96,
                    child: Row(children: [
                      _buildTextField(IEmployee.column_type, "[正式、劳务派遣、退休返聘、借调、实习、其他]",
                          defaultValue: employee?.get(IEmployee.column_type), validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_social, "[是/否]",
                          defaultValue: employee?.get(IEmployee.column_social), validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_company, "请输入公司名称",
                          defaultValue: employee?.get(IEmployee.column_company), validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_departments, "请输入工作部门",
                          defaultValue: employee?.get(IEmployee.column_departments),
                          validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_unionName, "如参加工会，请填写工会名称",
                          defaultValue: employee?.get(IEmployee.column_unionName)),
                    ]),
                  ),
                  SizedBox(
                      height: 96,
                      child: Row(children: [
                        _buildTextField(IEmployee.column_note, "请填写备注"),
                        const Expanded(child: SizedBox()),
                        const Expanded(child: SizedBox()),
                        const Expanded(child: SizedBox()),
                        const Expanded(child: SizedBox()),
                      ])),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _insertEmployee,
                        child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                            child: Text("确认", style: TextStyle(fontSize: 16))),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }

  String? _emptyValueValidator(String? value) {
    if (value == null || value.isEmpty) return "不能为空";
    return null;
  }

  String? _identifyIdValidator(String? value) {
    final result = _emptyValueValidator(value);
    if (result != null) return result;
    return EmployeeUtil.verifyIdentifyId(value!);
  }

  String? _phoneValidator(String? value) {
    final result = _emptyValueValidator(value);
    if (result != null) return result;
    if (value!.length != 11) return "请输入11位有效号码";
    return null;
  }

  bool _hasErrorField = false;

  void validateField(GlobalKey<FormFieldState<dynamic>> globalKey) {
    _hasErrorField = !globalKey.currentState!.validate() || _hasErrorField;
  }

  void _insertEmployee() async {
    _hasErrorField = false;
    _textFieldKeys.forEach(validateField);
    final values = _textFieldKeys.map<String>((e) => e.currentState?.value ?? "").toList(growable: false);
    logger.i("list: $values");
    if (_hasErrorField) return;
    final employee = Employee.fromValues(values);
    if (!employee.hasInvalidField) {
      final result = await (_updateEmployee ? _provider.update(employee) : _provider.insert(employee));
      Navigator.of(context).pop(result);
    } else {
      logger.i("invalidFields: ${employee.invalidFields.toString()}");
    }
  }

  Widget _buildTextField(
    String labelText,
    String hintText, {
    String? defaultValue,
    TextEditingController? controller,
    TextInputType type = TextInputType.text,
    List<FormFieldValidator<String>>? validators,
    int flex = 1,
  }) {
    final key = GlobalKey<FormFieldState>();
    final child = TextFormField(
      key: key,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      initialValue: defaultValue,
      keyboardType: type,
      controller: controller,
      validator: (value) {
        if (validators == null || validators.isEmpty) return null;
        String? result;
        for (var validator in validators) {
          result = validator(value);
          if (result != null && result.isNotEmpty) {
            break;
          }
        }
        return result;
      },
      autovalidateMode: AutovalidateMode.disabled,
      onEditingComplete: () {
        if (_focusScopeNode.focusedChild != _focusScopeNode.children.last) {
          _focusScopeNode.nextFocus();
        }
      },
    );
    _textFieldKeys.add(key);
    return Expanded(
      flex: flex,
      child: Padding(padding: const EdgeInsets.all(6), child: child),
    );
  }
}
