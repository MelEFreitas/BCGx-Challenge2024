import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/widgtes/chat_display.dart';
import 'package:frontend/presentation/home/widgtes/chat_input.dart';
import 'package:frontend/presentation/home/widgtes/drawer_menu.dart';
import 'package:frontend/presentation/home/widgtes/responsive_app_bar.dart';
import 'package:frontend/presentation/home/widgtes/side_panel.dart';
import 'package:frontend/presentation/home/widgtes/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      drawer:
          screenWidth < 900 ? const DrawerMenu() : null,
      appBar: screenWidth < 900
          ? const ResponsiveAppBar()
          : null,
      body: Row(
        children: [
          if (screenWidth >= 900) const SidePanel(),
          Expanded(
            child: Column(
              children: [
                if (screenWidth >= 900) const TopBar(),
                const Expanded(
                  child: ChatDisplay(),
                ),
                const ChatInputField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
