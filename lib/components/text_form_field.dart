import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController myController;
  final bool isPassword;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final String? labelText;
  final int maxLines;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.myController,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.validator,
    this.prefixIcon,
    this.labelText,
    this.maxLines = 1,
    this.autofillHints,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextFormField> createState() =>
      _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.myController,
      enabled: widget.enabled,
      obscureText: widget.isPassword && _hidePassword,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _hidePassword
                    ? 'Show password'
                    : 'Hide password',
                onPressed: widget.enabled
                    ? () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      }
                    : null,
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : null,
      ),
    );
  }
}