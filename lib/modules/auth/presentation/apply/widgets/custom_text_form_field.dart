import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.validator,
    required this.label,
    this.controller,
  });

  final String? Function(String?)? validator;
  final String label;
  final bool isRequired = true;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: isRequired ? "$label *" : label),
    );
  }
}
