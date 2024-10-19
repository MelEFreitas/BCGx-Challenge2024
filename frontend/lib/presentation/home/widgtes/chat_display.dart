import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatDisplay extends StatefulWidget {
  const ChatDisplay({super.key});

  @override
  State<ChatDisplay> createState() => _ChatDisplayState();
}

class _ChatDisplayState extends State<ChatDisplay> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocBuilder<GetChatCubit, GetChatState>(
      builder: (context, state) {
        if (state is GetChatStateInitial) {
          return Center(child: Text(localizations.startChat));
        } else if (state is GetChatStateFailure) {
          return Center(
              child: Text('Failed to load chat: ${state.errorMessage}'));
        } else if (state is GetChatStateSuccess) {
          final chat = state.chat;

          // Display the list of questions and answers
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8.0),
            itemCount: chat.conversation.length * 2,
            itemBuilder: (context, index) {
              final qaIndex = index ~/ 2;
              final isQuestion = index.isEven;
              final qa = chat.conversation[qaIndex];

              return Align(
                alignment:
                    isQuestion ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: isQuestion
                      ? EdgeInsets.fromLTRB(screenWidth > 900 ? screenWidth / 5 : screenWidth / 10, 10.0, screenWidth > 900 ? 20.0 : 10.0, 10.0)
                      : EdgeInsets.fromLTRB(screenWidth > 900 ? 30.0 : 20.0, 10.0, screenWidth > 900 ? screenWidth / 10 : screenWidth / 50, 10.0),
                  child: isQuestion ? 
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isQuestion ? ThemeColors.logoLightOrange : ThemeColors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(isQuestion ? qa.question : qa.answer, style: TextStyle(fontSize: screenWidth > 900 ? 19 : 17),),
                    )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/small_icon.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isQuestion ? ThemeColors.logoLightOrange : ThemeColors.grey,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(isQuestion ? qa.question : qa.answer, style: TextStyle(fontSize: screenWidth > 900 ? 19 : 17),),
                          ),
                        )
                      ],
                    )
                ),
              );
            },
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
