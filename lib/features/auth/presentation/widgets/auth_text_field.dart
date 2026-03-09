import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Reusable styled text field for authentication screens
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLength;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength = 100,
    this.enabled = true,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If there is text or it is focused, the label should float
    final bool shouldFloat = _isFocused || widget.controller.text.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Input Field Container
        Container(
          margin: const EdgeInsets.only(top: 8), // Room for floating label
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _isFocused
                  ? AppColors.secondary
                  : AppColors.glassBorder.withAlpha(100),
              width: _isFocused ? 2 : 0.5,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            validator: widget.validator,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: shouldFloat ? widget.hintText : widget.labelText,
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 18),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.secondary, size: 22)
                  : null,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),

        // Custom Floating Label
        if (shouldFloat)
          Positioned(
            left: 28, // Align with input padding
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: AppColors.darkBgSecondary, // Matches app background
              child: Text(
                widget.labelText,
                style: TextStyle(
                  color: _isFocused
                      ? AppColors.secondary
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Exo 2',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
