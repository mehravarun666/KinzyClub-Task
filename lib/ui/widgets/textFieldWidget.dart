import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: Colors.white,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        floatingLabelStyle: const TextStyle(
          color: Colors.white, // White color when focused and floating
        ),
        labelText: widget.labelText,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: widget.isPassword && _obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
    );
  }
}
