import 'package:flutter/material.dart';
import '../models/user_model.dart';

class RoleBadge extends StatelessWidget {
  final UserRole role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;

    switch (role) {
      case UserRole.guest:
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF475569);
        border = const Color(0xFFCBD5E1);
        break;
      case UserRole.individual:
        bg = const Color(0xFFF5F3FF);
        text = const Color(0xFF6D28D9);
        border = const Color(0xFFDDD6FE);
        break;
      case UserRole.employer:
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF1D4ED8);
        border = const Color(0xFFBFDBFE);
        break;
      case UserRole.trainer:
        bg = const Color(0xFFF0FDF4);
        text = const Color(0xFF15803D);
        border = const Color(0xFFBBF7D0);
        break;
      case UserRole.superAdmin:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFB45309);
        border = const Color(0xFFFDE68A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_rounded, size: 12, color: text),
          const SizedBox(width: 5),
          Text(
            role.badgeText,
            style: TextStyle(
              color: text,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
