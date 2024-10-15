// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
// import 'package:frontend/presentation/home/cubits/create_chat/create_chat_cubit.dart';
// import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
// import 'package:frontend/presentation/home/cubits/update_chat/update_chat_cubit.dart';

// class ChatInputField extends StatefulWidget {
//   const ChatInputField({super.key});

//   @override
//   State<ChatInputField> createState() => _ChatInputFieldState();
// }

// class _ChatInputFieldState extends State<ChatInputField> {
//   final TextEditingController messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
//       child: BlocBuilder<GetChatCubit, GetChatState>(
//         builder: (context, getChatState) {
//           final bool isLoading = context.watch<CreateChatCubit>().state
//                   is CreateChatStateLoading ||
//               context.watch<UpdateChatCubit>().state is UpdateChatStateLoading;

//           return Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: messageController,
//                   decoration: const InputDecoration(
//                     hintText: 'Type a message...',
//                     border: OutlineInputBorder(),
//                   ),
//                   minLines: 1,
//                   maxLines: 7,
//                   expands: false,
//                 ),
//               ),
//               const SizedBox(width: 20),
//               BlocListener<CreateChatCubit, CreateChatState>(
//                 listener: (context, createChatState) {
//                   if (createChatState is CreateChatStateSuccess) {
//                     final chatId = createChatState.chat.id;
//                     context.read<GetChatCubit>().getChat(chatId);
//                     context.read<GetChatSummariesCubit>().getAllChatSummaries();
//                   }
//                 },
//                 child: IconButton(
//                   icon: isLoading
//                       ? const CircularProgressIndicator()
//                       : const Icon(Icons.send),
//                   onPressed: isLoading
//                       ? null
//                       : () async {
//                           final message = messageController.text.trim();
//                           if (message.isEmpty) return;
//                           if (getChatState is GetChatStateSuccess) {
//                             final chatId = getChatState.chat.id;
//                             await context
//                                 .read<UpdateChatCubit>()
//                                 .updateChat(chatId, message);
//                             if (context.mounted) {
//                               await context
//                                   .read<GetChatCubit>()
//                                   .getChat(chatId);
//                             }
//                           } else if (getChatState is GetChatStateInitial) {
//                             await context
//                                 .read<CreateChatCubit>()
//                                 .createChat(message);
//                             if (context.mounted) {
//                               await context
//                                   .read<GetChatSummariesCubit>()
//                                   .getAllChatSummaries();
//                             }
//                           }
//                           messageController.clear();
//                         },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
// import 'package:frontend/presentation/home/cubits/create_chat/create_chat_cubit.dart';
// import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
// import 'package:frontend/presentation/home/cubits/update_chat/update_chat_cubit.dart';

// class ChatInputField extends StatefulWidget {
//   const ChatInputField({super.key});

//   @override
//   State<ChatInputField> createState() => _ChatInputFieldState();
// }

// class _ChatInputFieldState extends State<ChatInputField> {
//   final TextEditingController messageController = TextEditingController();

//   // List of predefined words to show as selectable cards
//   final List<String> words = ['Climate', 'Energy', 'Pollution', 'Waste', 'Green', 'Water'];

//   // To keep track of the selected words
//   List<String> selectedWords = [];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
//       child: BlocBuilder<GetChatCubit, GetChatState>(
//         builder: (context, getChatState) {
//           final bool isLoading = context.watch<CreateChatCubit>().state
//                   is CreateChatStateLoading ||
//               context.watch<UpdateChatCubit>().state is UpdateChatStateLoading;

//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Row of selectable word cards
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: words.map((word) {
//                     final bool isSelected = selectedWords.contains(word);
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: ChoiceChip(
//                         label: Text(word),
//                         selected: isSelected,
//                         onSelected: (selected) {
//                           setState(() {
//                             if (selected && selectedWords.length < 3) {
//                               // Add the word to the selectedWords if less than 3 are selected
//                               selectedWords.add(word);
//                             } else if (!selected) {
//                               // Remove the word if it is deselected
//                               selectedWords.remove(word);
//                             }
//                           });
//                         },
//                         selectedColor: Colors.blue[100],
//                         backgroundColor: Colors.grey[200],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: messageController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                       ),
//                       minLines: 1,
//                       maxLines: 7,
//                       expands: false,
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   BlocListener<CreateChatCubit, CreateChatState>(
//                     listener: (context, createChatState) {
//                       if (createChatState is CreateChatStateSuccess) {
//                         final chatId = createChatState.chat.id;
//                         context.read<GetChatCubit>().getChat(chatId);
//                         context.read<GetChatSummariesCubit>().getAllChatSummaries();
//                       }
//                     },
//                     child: IconButton(
//                       icon: isLoading
//                           ? const CircularProgressIndicator()
//                           : const Icon(Icons.send),
//                       onPressed: isLoading
//                           ? null
//                           : () async {
//                               final message = messageController.text.trim();

//                               // Combine the selected words and message text
//                               final combinedMessage =
//                                   (selectedWords.isNotEmpty ? '${selectedWords.join(', ')}: ' : '') + message;

//                               if (combinedMessage.isEmpty) return;

//                               if (getChatState is GetChatStateSuccess) {
//                                 final chatId = getChatState.chat.id;
//                                 await context
//                                     .read<UpdateChatCubit>()
//                                     .updateChat(chatId, combinedMessage);
//                                 if (context.mounted) {
//                                   await context
//                                       .read<GetChatCubit>()
//                                       .getChat(chatId);
//                                 }
//                               } else if (getChatState is GetChatStateInitial) {
//                                 await context
//                                     .read<CreateChatCubit>()
//                                     .createChat(combinedMessage);
//                                 if (context.mounted) {
//                                   await context
//                                       .read<GetChatSummariesCubit>()
//                                       .getAllChatSummaries();
//                                 }
//                               }
//                               // Clear the input field and the selected words
//                               messageController.clear();
//                               setState(() {
//                                 selectedWords.clear();
//                               });
//                             },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

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

  // List of predefined words to show as selectable cards
  final List<String> words = [
    'Climate',
    'Energy',
    'Pollution',
    'Waste',
    'Green',
    'Water'
  ];

  // To keep track of the selected words
  List<String> selectedWords = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
      child: BlocBuilder<GetChatCubit, GetChatState>(
        builder: (context, getChatState) {
          final bool isLoading = context.watch<CreateChatCubit>().state
                  is CreateChatStateLoading ||
              context.watch<UpdateChatCubit>().state is UpdateChatStateLoading;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row of selectable word cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: words.map((word) {
                    final bool isSelected = selectedWords.contains(word);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(word),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected && selectedWords.length < 3) {
                              // Add the word to the selectedWords if less than 3 are selected
                              selectedWords.add(word);
                            } else if (!selected) {
                              // Remove the word if it is deselected
                              selectedWords.remove(word);
                            }
                          });
                        },
                        selectedColor: Colors.blue[100],
                        backgroundColor: Colors.grey[200],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
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
                      message: 'Send the message',
                      child: IconButton(
                        icon: isLoading
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.send),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final message = messageController.text.trim();

                                // Combine the selected words and message text
                                final combinedMessage =
                                    (selectedWords.isNotEmpty
                                            ? '${selectedWords.join(', ')}: '
                                            : '') +
                                        message;

                                if (message.isEmpty) return;

                                if (getChatState is GetChatStateSuccess) {
                                  final chatId = getChatState.chat.id;
                                  await context
                                      .read<UpdateChatCubit>()
                                      .updateChat(chatId, combinedMessage);
                                  if (context.mounted) {
                                    await context
                                        .read<GetChatCubit>()
                                        .getChat(chatId);
                                  }
                                } else if (getChatState
                                    is GetChatStateInitial) {
                                  await context
                                      .read<CreateChatCubit>()
                                      .createChat(combinedMessage);
                                  if (context.mounted) {
                                    await context
                                        .read<GetChatSummariesCubit>()
                                        .getAllChatSummaries();
                                  }
                                }
                                // Only clear the input field after sending the message, not the selected words
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
