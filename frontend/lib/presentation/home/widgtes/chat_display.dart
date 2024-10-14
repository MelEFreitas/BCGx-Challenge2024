import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';

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
        duration: const Duration(milliseconds: 3000),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetChatCubit, GetChatState>(
      builder: (context, state) {
        if (state is GetChatStateInitial) {
          return const Center(child: Text('Send a message to start a chat!'));
        } else if (state is GetChatStateFailure) {
          return Center(child: Text('Failed to load chat: ${state.errorMessage}'));
        } else if (state is GetChatStateSuccess) {
          final chat = state.chat;

          // Display the list of questions and answers
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          return ListView.builder(
            controller: _scrollController, // Attach the ScrollController
            padding: const EdgeInsets.all(8.0),
            itemCount: chat.conversation.length * 2, // Each question and answer is separate
            itemBuilder: (context, index) {
              final qaIndex = index ~/ 2; // Dividing index by 2 to get the corresponding QuestionAnswerEntity
              final isQuestion = index.isEven; // Even indices represent questions, odd ones represent answers
              final qa = chat.conversation[qaIndex];

              return Align(
                alignment: isQuestion ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: isQuestion
                      ? const EdgeInsets.fromLTRB(400.0, 10.0, 10.0, 10.0)
                      : const EdgeInsets.fromLTRB(10.0, 10.0, 400.0, 10.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isQuestion ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(isQuestion ? qa.question : qa.answer),
                  ),
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
