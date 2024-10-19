import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.borderRadius = 10,
    required this.label,
    this.forColor,
    this.bgColor,
    this.needimage = false,
    this.image,
    required this.onPressed,
  });
  final double borderRadius;
  final String label;

  final Color? bgColor;
  final Color? forColor;

  final VoidCallback onPressed;

  final bool needimage;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            backgroundColor: bgColor ?? const Color(0xFF3B82F6),
            foregroundColor: forColor ?? Colors.white),
        onPressed: onPressed,
        child: Stack(
          children: [
            needimage
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      image!,
                      scale: 18,
                    ),
                  )
                : const SizedBox.shrink(),
            Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
