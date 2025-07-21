import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  const AuthTextfield({super.key, required this.controller, required this.label, required this.obscure});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                )
              ),
            ),
          );
  }
}