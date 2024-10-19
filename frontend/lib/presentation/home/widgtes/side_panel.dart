import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/widgtes/chat_history.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      width: 350,
      child: Column(
        children: [
          Container(
            color: ThemeColors.darkGreen,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(
                    color: ThemeColors.lightGrey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Tooltip(
                  message: localizations.startChat,
                  child: IconButton(
                    hoverColor: const Color.fromARGB(50, 255, 255, 255),
                    icon: const Icon(Icons.edit, color: ThemeColors.lightGrey),
                    onPressed: () {
                      context.read<GetChatCubit>().resetChat();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
            height: 1.0,
          ),
          Expanded(child: Container(color: ThemeColors.darkGreen, child: const ChatHistory())),
        ],
      ),
    );
  }
}
