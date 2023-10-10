import 'package:flutter/material.dart';
import 'package:poc_glow/ui/shared_widgets/glow_button.dart';

class CreatePaymentSessionScreen extends StatelessWidget {
  final void Function() onPressed;
  const CreatePaymentSessionScreen({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 188,
          child: GlowButton(
            EdgeInsets.zero,
            child: const Text("Create Payment"),
            isAccent: true,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
