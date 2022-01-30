import 'package:flutter/material.dart';

class PolyTextField extends StatelessWidget {
  const PolyTextField({
    Key? key,
    required this.controller,
    required this.placeholder,
  }) : super(key: key);
  final TextEditingController controller;

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: TextFormField(
        key: const Key('PolynomialInputField-TextFormField'),
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
            ),
          ),
          hintText: placeholder,
        ),
        validator: (value) => _validationLogic(value),
      ),
    );
  }
}

String? _validationLogic(String? value) {
  if (value != null) {
    if (!(double.tryParse(value) != null)) {
      return "Invalid input";
    }
  }
}
