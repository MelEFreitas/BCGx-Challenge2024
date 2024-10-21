import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/widgtes/chat_display.dart';
import 'package:frontend/presentation/home/widgtes/chat_input.dart';
import 'package:frontend/presentation/home/widgtes/drawer_menu.dart';
import 'package:frontend/presentation/home/widgtes/responsive_app_bar.dart';
import 'package:frontend/presentation/home/widgtes/side_panel.dart';
import 'package:frontend/presentation/home/widgtes/top_bar.dart';

/// The [HomeScreen] widget serves as the main interface for the chat application.
///
/// It displays the chat interface, including a chat display area, an input field
/// for sending messages, and a responsive layout that adapts based on screen width.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive layout decisions.
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      // Show the drawer menu if the screen width is less than 900 pixels.
      drawer: screenWidth < 900 ? const DrawerMenu() : null,

      // Use a responsive app bar for smaller screens.
      appBar: screenWidth < 900 ? const ResponsiveAppBar() : null,

      body: Row(
        children: [
          // Display a side panel for larger screens (900 pixels or wider).
          if (screenWidth >= 900) const SidePanel(),

          Expanded(
            child: Column(
              children: [
                // Display a top bar for larger screens.
                if (screenWidth >= 900) const TopBar(),

                // Main chat display area.
                const Expanded(
                  child: ChatDisplay(),
                ),

                // Input field for sending messages.
                const ChatInputField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
