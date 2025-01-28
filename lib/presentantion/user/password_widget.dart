import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator validator;

  const PasswordTextField(
      {Key? key, required this.controller, required this.validator})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true; // Initial state of password visibility

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured, // Controls whether the text is obscured
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured; // Toggle the visibility state
            });
          },
        ),
      ),
    );
  }
}
