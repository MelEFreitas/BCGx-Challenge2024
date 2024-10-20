import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';

/// A widget that allows users to select a role from a list.
///
/// The [RoleSelector] displays a horizontal list of roles, each represented 
/// as a selectable card. The selected role is visually highlighted, and 
/// a callback is invoked when a role is selected.
class RoleSelector extends StatelessWidget {
  /// A list of roles to display, where each role is represented 
  /// as a map containing its title and description.
  final List<Map<String, String>> roles;

  /// The index of the currently selected role.
  final int selectedRole;

  /// A callback function that is called when a role is selected.
  /// It receives the index of the selected role as a parameter.
  final Function(int) onRoleSelected;

  /// Creates an instance of [RoleSelector].
  ///
  /// The [roles], [selectedRole], and [onRoleSelected] parameters are required.
  const RoleSelector({
    super.key,
    required this.roles,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  /// Builds the widget that displays the role selector.
  ///
  /// This method creates a row of selectable roles. Each role is displayed 
  /// in a container that changes appearance based on whether it is selected.
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
                  color: selectedRole == index 
                      ? ThemeColors.darkGreen 
                      : Colors.grey,
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
