import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/widgtes/chat_history.dart';

/// A stateless widget representing a navigation drawer for chat functionality.
///
/// The [DrawerMenu] widget displays a header with the title "Chats" and an icon
/// button to reset the chat. It also includes a list of chat histories
/// displayed below the header. The drawer is styled with a dark green
/// background to maintain consistency with the application's theme.
///
/// This widget interacts with the [GetChatCubit] to reset the chat when the
/// icon button is pressed, and it uses the [Navigator] to close the drawer
/// after the action is performed.
class DrawerMenu extends StatelessWidget {
  /// Creates a [DrawerMenu] widget.
  ///
  /// This constructor accepts an optional [key] parameter, which can be 
  /// used to identify the widget in the widget tree.
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header section of the drawer.
          DrawerHeader(
            margin: EdgeInsets.zero, // No margin around the header.
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0), // Padding for the header.
            decoration: const BoxDecoration(
              color: ThemeColors.darkGreen, // Background color for the header.
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between header elements.
              children: [
                const Text(
                  'Chats', // Title of the drawer.
                  style: TextStyle(
                    color: ThemeColors.lightGrey, // Text color for the title.
                    fontSize: 24, // Font size for the title.
                    fontWeight: FontWeight.bold, // Bold font weight for the title.
                  ),
                ),
                // Icon button to reset the chat.
                IconButton(
                  hoverColor: const Color.fromARGB(50, 255, 255, 255), // Hover color for the button.
                  icon: const Icon(Icons.edit, color: ThemeColors.lightGrey), // Edit icon.
                  onPressed: () {
                    // Reset the chat and close the drawer when the button is pressed.
                    context.read<GetChatCubit>().resetChat(); // Resetting the chat.
                    Navigator.of(context).pop(); // Close the drawer.
                  },
                ),
              ],
            ),
          ),
          // Expanded widget to display chat history.
          Expanded(
            child: Container(
              color: ThemeColors.darkGreen, // Background color for chat history.
              child: const ChatHistory(), // Display the chat history widget.
            ),
          ),
        ],
      ),
    );
  }
}
