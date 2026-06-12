import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final Widget icon;
  final TextStyle thisStyle;

  const LoginButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.text,
    required this.textColor,
    required this.icon,
    required this.thisStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 13,
                left: 16,
                child: icon,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: thisStyle.copyWith(
                    color: textColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
