import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubits/delete_chat/delete_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetChatSummariesCubit, GetChatSummariesState>(
      builder: (context, state) {
        if (state is GetChatSummariesStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetChatSummariesStateFailure) {
          return Center(
              child:
                  Text('Failed to load chat summaries: ${state.errorMessage}'));
        } else if (state is GetChatSummariesStateSuccess) {
          final summaries = state.chatSummaries;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: summaries.length,
            itemBuilder: (context, index) {
              final summary = summaries[index];
              return ListTile(
                title: Text(summary.title),
                onTap: () async {
                  await context.read<GetChatCubit>().getChat(summary.chatId);
                },
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context, summary.chatId);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Delete Chat',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('To start a chat, send a message.'));
        }
      },
    );
  }

  // Show a confirmation dialog before deleting
  void _showDeleteDialog(BuildContext context, int chatId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Chat'),
          content: const Text('Are you sure you want to delete this chat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<DeleteChatCubit>().deleteChat(chatId);
                if (context.mounted) context.read<GetChatCubit>().resetChat();
                if (context.mounted) await context.read<GetChatSummariesCubit>().getAllChatSummaries();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

