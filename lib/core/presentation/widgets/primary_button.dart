import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isExpanded = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isExpanded;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: Text(label),
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: Text(label),
          );

    if (!isExpanded) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
