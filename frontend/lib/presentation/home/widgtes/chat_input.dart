import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/create_chat/create_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
import 'package:frontend/presentation/home/cubits/update_chat/update_chat_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth > 900 ? screenWidth / 10 : screenWidth / 50, vertical: 50),
      child: BlocBuilder<GetChatCubit, GetChatState>(
        builder: (context, getChatState) {
          final bool isLoading = context.watch<CreateChatCubit>().state
                  is CreateChatStateLoading ||
              context.watch<UpdateChatCubit>().state is UpdateChatStateLoading;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: localizations.typeMessage,
                        hintStyle: const TextStyle(
                          color: ThemeColors.darkGreen
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ThemeColors.darkGreen,
                          ),
                        ),
                        focusColor: ThemeColors.darkGreen,
                        focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ThemeColors.darkGreen,
                          ),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 7,
                      expands: false,
                    ),
                  ),
                  const SizedBox(width: 20),
                  BlocListener<CreateChatCubit, CreateChatState>(
                    listener: (context, createChatState) {
                      if (createChatState is CreateChatStateSuccess) {
                        final chatId = createChatState.chat.id;
                        context.read<GetChatCubit>().getChat(chatId);
                        context
                            .read<GetChatSummariesCubit>()
                            .getAllChatSummaries();
                      }
                    },
                    child: Tooltip(
                      message: localizations.sendMessage,
                      child: IconButton(
                        icon: isLoading
                            ? const CircularProgressIndicator(color: ThemeColors.logoOrange,)
                            : const Icon(Icons.send, color: ThemeColors.logoOrange,),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final message = messageController.text.trim();

                                if (message.isEmpty) return;

                                if (getChatState is GetChatStateSuccess) {
                                  final chatId = getChatState.chat.id;
                                  await context
                                      .read<UpdateChatCubit>()
                                      .updateChat(chatId, message);
                                  if (context.mounted) {
                                    await context
                                        .read<GetChatCubit>()
                                        .getChat(chatId);
                                  }
                                } else if (getChatState
                                    is GetChatStateInitial) {
                                  await context
                                      .read<CreateChatCubit>()
                                      .createChat(message);
                                  if (context.mounted) {
                                    await context
                                        .read<GetChatSummariesCubit>()
                                        .getAllChatSummaries();
                                  }
                                }
                                messageController.clear();
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
