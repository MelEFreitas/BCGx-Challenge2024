import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';

class RoleSelector extends StatelessWidget {
  final List<Map<String, String>> roles;
  final int selectedRole;
  final Function(int) onRoleSelected;

  const RoleSelector({
    super.key,
    required this.roles,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: roles.asMap().entries.map((entry) {
        int index = entry.key;
        String roleTitle = entry.value["title"]!;
        String roleDescription = entry.value["description"]!;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onRoleSelected(index),
            child: Container(
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: selectedRole == index
                    ? ThemeColors.roleSelected
                    : ThemeColors.lightGrey,
                border: Border.all(
                  color: selectedRole == index ? ThemeColors.darkGreen : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roleTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(roleDescription),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
