import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/widgtes/chat_history.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            decoration: const BoxDecoration(
              color: ThemeColors.darkGreen,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(
                    color: ThemeColors.lightGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  hoverColor: const Color.fromARGB(50, 255, 255, 255),
                  icon: const Icon(Icons.edit, color: ThemeColors.lightGrey),
                  onPressed: () {
                    context.read<GetChatCubit>().resetChat();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Expanded(child: Container(color: ThemeColors.darkGreen, child: const ChatHistory())),
        ],
      ),
    );
  }
}
