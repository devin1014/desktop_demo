import 'package:desktop_demo/database/employee.dart';
import 'package:desktop_demo/database/provider.dart';
import 'package:desktop_demo/database/util.dart';
import 'package:flutter/material.dart';

class InsertEmployeePage extends StatefulWidget {
  const InsertEmployeePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InsertEmployeePageState();
}

class _InsertEmployeePageState extends State<InsertEmployeePage> {
  final DatabaseProvider _provider = DatabaseProvider();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final List<GlobalKey<FormFieldState>> _textFieldKeys = [];

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
    _textFieldKeys.clear();
    return Scaffold(
        appBar: AppBar(title: const Text("新增人员信息")),
        body: FocusScope(
          node: _focusScopeNode,
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                      height: 96,
                      child: Row(children: [
                        _buildTextField(IEmployee.column_name, "请输入名字", validators: [_emptyValueValidator]),
                        _buildTextField(IEmployee.column_identifyType, "请输入证件类型", validators: [_emptyValueValidator]),
                        // _buildDropDownButton(IEmployee.value_identify_types),
                        _buildTextField(IEmployee.column_identifyId, "请输入证件号码", validators: [_identifyIdValidator]),
                        _buildTextField(IEmployee.column_gender, "男/女", validators: [_emptyValueValidator]),
                        _buildTextField(IEmployee.column_phone, "请输入11位手机号码",
                            type: TextInputType.phone, validators: [_phoneValidator]),
                      ])),
                  SizedBox(
                    height: 96,
                    child: Row(children: [
                      _buildTextField(IEmployee.column_type, "[正式、劳务派遣、退休返聘、借调、实习、其他]",
                          validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_social, "[是/否]", validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_company, "请输入公司名称", validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_departments, "请输入工作部门", validators: [_emptyValueValidator]),
                      _buildTextField(IEmployee.column_unionName, "如参加工会，请填写工会名称"),
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

  void _insertEmployee() {
    _hasErrorField = false;
    _textFieldKeys.forEach(validateField);
    final values = _textFieldKeys.map<String>((e) => e.currentState?.value ?? "").toList(growable: false);
    print("list: $values");
    if (_hasErrorField) return;
    final employee = Employee.fromValues(values);
    if (!employee.hasInvalidField) {
      _provider.insert(employee);
    } else {
      print("invalidFields: ${employee.invalidFields.toString()}");
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

// Widget _buildDropDownButton(List<String> values, {int flex = 1}) {
//   final items = values
//       .map((e) => DropdownMenuItem<String>(
//             child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(e)),
//           ))
//       .toList(growable: false);
//   return Expanded(
//     flex: flex,
//     child: DropdownButton(
//       // value: values.first,
//       items: items,
//       selectedItemBuilder: (context) {
//         return values.map((e) => Center(child: Text(e))).toList(growable: false);
//       },
//       onChanged: (value) {},
//     ),
//   );
// }
}
