import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/create_chat/create_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
import 'package:frontend/presentation/home/cubits/update_chat/update_chat_cubit.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
      child: BlocBuilder<GetChatCubit, GetChatState>(
        builder: (context, getChatState) {
          // Using the loading state of both the Create and Update Cubits
          final bool isLoading = context.watch<CreateChatCubit>().state
                  is CreateChatStateLoading ||
              context.watch<UpdateChatCubit>().state is UpdateChatStateLoading;

          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 1, // Minimum number of visible lines
                  maxLines: 7, // Maximum number of visible lines before scrolling
                  expands: false, // Allows it to grow vertically
                ),
              ),
              const SizedBox(width: 20),
              BlocListener<CreateChatCubit, CreateChatState>(
                listener: (context, createChatState) {
                  if (createChatState is CreateChatStateSuccess) {
                    final chatId = createChatState.chat.id;
                    context.read<GetChatCubit>().getChat(chatId);
                    context.read<GetChatSummariesCubit>().getAllChatSummaries();
                  }
                },
                child: IconButton(
                  icon: isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                  onPressed: isLoading
                      ? null // Disable the button during loading
                      : () async {
                          final message = messageController.text.trim();
                          if (message.isEmpty) return;
                          if (getChatState is GetChatStateSuccess) {
                            // Case 1: Update existing chat
                            final chatId = getChatState.chat.id;
                            await context
                                .read<UpdateChatCubit>()
                                .updateChat(chatId, message);
                            if (context.mounted) {
                              await context
                                  .read<GetChatCubit>()
                                  .getChat(chatId);
                            }
                          } else if (getChatState is GetChatStateInitial) {
                            // Case 2: Create a new chat
                            await context
                                .read<CreateChatCubit>()
                                .createChat(message);
                            if (context.mounted) {
                              await context
                                  .read<GetChatSummariesCubit>()
                                  .getAllChatSummaries();
                            }
                          }
                          // Clear the input field after sending the message
                          messageController.clear();
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
