import 'package:flutter/material.dart';

// Celui-ci gère automatiquement l'icône "œil" pour cacher/montrer le mot de passe.

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final int maxLines;

  const CustomTextField({
  super.key,
  required this.label,
  this.controller,
  this.hint,
  this.validator,
  this.obscureText = false,
  this.keyboardType,
  this.prefixIcon,
  this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
  }

  class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
  super.initState();
  _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
  return TextFormField(
  controller: widget.controller,
  obscureText: _isObscured,
  keyboardType: widget.keyboardType,
  maxLines: widget.maxLines,
  validator: widget.validator,
  decoration: InputDecoration(
  labelText: widget.label,
  hintText: widget.hint,
  prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
  suffixIcon: widget.obscureText
  ? IconButton(
  icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
  onPressed: () => setState(() => _isObscured = !_isObscured),
  )
      : null,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  ),
  );
  }
  }