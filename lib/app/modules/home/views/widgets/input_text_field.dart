import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextField extends StatelessWidget {
  const InputTextField(
      {super.key,
      this.validator,
      required this.controller,
      this.hint,
      this.format,
      this.textAction,
      this.keyBoardType,
      this.enabled});
  final TextEditingController controller;
  final String? hint;
  final List<TextInputFormatter>? format;
  final TextInputAction? textAction;
  final String? Function(String?)? validator;
  final TextInputType? keyBoardType;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextFormField(
      enabled: enabled,
      style: theme.textTheme.bodyMedium,
      textInputAction: textAction,
      keyboardType: keyBoardType,
      inputFormatters: format,
      controller: controller,
      decoration: InputDecoration(
          // fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          hintText: hint,
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.textTheme.bodyMedium!.color!),
              borderRadius: BorderRadius.circular(16.r)),
          focusColor: Colors.transparent,
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.textTheme.bodyMedium!.color!),
              borderRadius: BorderRadius.circular(16.r)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.textTheme.bodyMedium!.color!),
              borderRadius: BorderRadius.circular(16.r)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.textTheme.bodyMedium!.color!),
              borderRadius: BorderRadius.circular(16.r)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.textTheme.bodyMedium!.color!),
              borderRadius: BorderRadius.circular(16.r)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.textTheme.bodyMedium!.color!),
              borderRadius: BorderRadius.circular(16.r))),
      validator: validator,
    );
  }
}
