import 'package:flutter/material.dart';

class BackBtnWidget extends StatelessWidget {
  const BackBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color:        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          size:  15,
        ),
      ),
    );
  }
}