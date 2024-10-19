import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
import 'package:frontend/presentation/home/widgtes/dialog_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<GetChatSummariesCubit, GetChatSummariesState>(
      builder: (context, chatSummariesState) {
        return BlocBuilder<GetChatCubit, GetChatState>(
          builder: (context, chatState) {
            final selectedChatId = chatState is GetChatStateSuccess ? chatState.chat.id : null;

            if (chatSummariesState is GetChatSummariesStateLoading) {
              return const Center(child: CircularProgressIndicator(color: ThemeColors.lightGreen));
            } else if (chatSummariesState is GetChatSummariesStateFailure) {
              return Center(
                  child: Text('Failed to load chat summaries =${chatSummariesState.errorMessage}'));
            } else if (chatSummariesState is GetChatSummariesStateSuccess) {
              final summaries = chatSummariesState.chatSummaries;

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: summaries.length,
                itemBuilder: (context, index) {
                  final summary = summaries[index];
                  final isSelected = summary.chatId == selectedChatId;

                  return HoverableChatTile(
                    summary: summary,
                    isSelected: isSelected,
                    localizations: localizations,
                  );
                },
              );
            } else {
              return const Center(child: Text(''));
            }
          },
        );
      },
    );
  }
}

class HoverableChatTile extends StatefulWidget {
  final dynamic summary;
  final bool isSelected;
  final AppLocalizations localizations;

  const HoverableChatTile({
    super.key,
    required this.summary,
    required this.isSelected,
    required this.localizations,
  });

  @override
  State<HoverableChatTile> createState() => _HoverableChatTileState();
}

class _HoverableChatTileState extends State<HoverableChatTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    const hoverColor = ThemeColors.lightGreenHover; // Color on hover
    final normalColor = widget.isSelected ? ThemeColors.lightGreen : Colors.transparent;
    final borderColor = widget.isSelected ? ThemeColors.darkGreen : Colors.transparent;
    final textColor = widget.isSelected ? ThemeColors.darkGreen : ThemeColors.lightGreen;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isHovered ? hoverColor : normalColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            widget.summary.title,
            style: TextStyle(
              color: textColor,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () async {
            await context.read<GetChatCubit>().getChat(widget.summary.chatId);
          },
          trailing: PopupMenuButton<String>(
            color: ThemeColors.lightGrey,
            icon: Icon(Icons.more_horiz, color: textColor),
            onSelected: (value) {
              if (value == 'delete') {
                showDeleteDialog(context, widget.summary.chatId);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        widget.localizations.deleteChat,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}


