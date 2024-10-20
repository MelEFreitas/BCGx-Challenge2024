import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/widgtes/chat_history.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A stateless widget representing a side panel for chat functionality.
///
/// The [SidePanel] widget displays a header with a title and an icon button
/// to start a new chat, as well as a list of chat histories. The panel is 
/// styled with a dark green background and includes localization support.
///
/// This widget uses the [GetChatCubit] to reset the chat when the icon 
/// button is pressed, ensuring that the user starts a new conversation
/// each time they click the button.
class SidePanel extends StatelessWidget {
  /// Creates a [SidePanel] widget.
  ///
  /// This constructor accepts an optional [key] parameter, which can be 
  /// used to identify the widget in the widget tree.
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain localized strings from the AppLocalizations class.
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: 350, // Fixed width for the side panel.
      child: Column(
        children: [
          // Header container with the title and the start chat button.
          Container(
            color: ThemeColors.darkGreen, // Background color for the header.
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding.
            height: 80.0, // Height of the header.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between children.
              children: [
                const Text(
                  'Chats', // Title of the panel.
                  style: TextStyle(
                    color: ThemeColors.lightGrey, // Text color for the title.
                    fontSize: 20, // Font size for the title.
                    fontWeight: FontWeight.bold, // Bold font weight for the title.
                  ),
                ),
                Tooltip(
                  message: localizations.startChat, // Tooltip for the button.
                  child: IconButton(
                    hoverColor: const Color.fromARGB(50, 255, 255, 255), // Hover color for the button.
                    icon: const Icon(Icons.edit, color: ThemeColors.lightGrey), // Edit icon.
                    onPressed: () {
                      // Reset the chat when the icon button is pressed.
                      context.read<GetChatCubit>().resetChat();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white, // Color of the divider.
            thickness: 1.0, // Thickness of the divider.
            height: 1.0, // Height around the divider.
          ),
          // Expanded widget to display the chat history.
          Expanded(
            child: Container(
              color: ThemeColors.darkGreen, // Background color for the chat history.
              child: const ChatHistory(), // Display the chat history.
            ),
          ),
        ],
      ),
    );
  }
}
