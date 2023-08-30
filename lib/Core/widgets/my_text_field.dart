import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class MyCustomTextField extends StatelessWidget {
  const MyCustomTextField({
    super.key,
    this.obsecureText,
    this.controller,
    required this.icon,
    this.keyboardType,
    this.focusNode,
    this.onChanged,
    required this.hintText,
  });
  final bool? obsecureText;
  final TextEditingController? controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.kSecondary, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: MyColors.kPrimary),
          Expanded(
            child: TextFormField(
              obscureText: obsecureText ?? false,
              controller: controller,
              keyboardType: keyboardType,
              focusNode: focusNode,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: hintText),
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
