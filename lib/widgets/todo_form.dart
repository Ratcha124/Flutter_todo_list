import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TodoForm extends StatefulWidget {
  final String? initialTitle;
  final Function(String) onSubmit;

  const TodoForm({Key? key, this.initialTitle, required this.onSubmit})
      : super(key: key);

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle ?? '';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_title.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.initialTitle == null ? 'เพิ่มรายการใหม่' : 'แก้ไขรายการ'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _title,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'ชื่องาน',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'กรุณากรอกชื่อรายการ'
              : null,
          onChanged: (val) => setState(() => _title = val),
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          child: const Text('บันทึก'),
        ),
      ],
    );
  }
}
