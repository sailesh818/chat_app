import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AuthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(onPressed: onPressed,
            child: Text(text, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
            ),
    );
  }
}