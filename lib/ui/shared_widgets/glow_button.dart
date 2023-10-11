import 'package:flutter/material.dart';
import 'package:poc_glow/main.dart';

class GlowButton extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;
  final bool isAccent;
  final void Function()? onPressed;

  const GlowButton(
    this.padding, {
    required this.child,
    this.isAccent = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildButton(padding, child, isAccent, context, onPressed);
  }

  Widget _buildButton(
    EdgeInsets padding,
    Widget child,
    bool isAccent,
    BuildContext context,
    void Function()? onPressed,
  ) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: isAccent ? primaryColor : backgroundColor,
            onPrimary: isAccent ? backgroundColor : primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
