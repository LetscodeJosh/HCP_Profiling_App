import 'package:flutter/material.dart';
import '../../services/api_service.dart';

/// Circular initials avatar styled with the HCP Nexus blue-teal theme.
/// Replaces designation acronyms (e.g. ITM) with the user's name initials (e.g. JT, DH, AM).
class UserInitialsAvatar extends StatelessWidget {
  final ApiService apiService;
  final double size;

  const UserInitialsAvatar({
    Key? key,
    required this.apiService,
    this.size = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initials = apiService.userInitials;
    final fullName = (apiService.loggedInFullName ?? '').trim();
    final email = (apiService.loggedInEmail ?? '').trim();
    final displayName = fullName.isNotEmpty ? fullName : (email.isNotEmpty ? email : 'User');
    final desig = apiService.userDesignationTitle;
    final tooltipText = desig.isNotEmpty ? '$displayName ($desig)' : displayName;

    return Tooltip(
      message: tooltipText,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF0056B3), Color(0xFF00A8E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFF38BDF8),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.39,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
