import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width < 600
          ? Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chats',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // No action for now
                          },
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: ChatHistory()), // Simulating past chats
                ],
              ),
            )
          : null,
      appBar: MediaQuery.of(context).size.width < 600
        ? AppBar(
          title: const Text('GenAI Chat'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // No action for now
              },
            ),
          ],
        )
      : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 600)
            SizedBox(
              width: 250, // Fixed sidebar width for larger screens
              child: Column(
                children: [
                  Container(
                    color: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chats',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // No action for now
                          },
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: ChatHistory()), // Simulating past chats
                ],
              ), // Simulating past chats
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Top row with title and gear icon
                      if (MediaQuery.of(context).size.width >= 600)
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 60.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'GenAI Chat',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  // No action for now
                                },
                              ),
                            ],
                          ),
                        ),
                      const Expanded(
                        child: ChatDisplay(), // Display area for chats
                      ),
                      const ChatInputField(), // Text input field for new messages
                    ],
                  ),
                ), // Text input field for new messages
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 10, // Simulating 10 past chats
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Chat $index'),
          onTap: () {
            // Handle chat selection
          },
        );
      },
    );
  }
}

class ChatDisplay extends StatelessWidget {
  const ChatDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 20, // Simulating 20 chat messages
      itemBuilder: (context, index) {
        bool isUser = index % 2 == 0; // Simulating user/AI alternate messages
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text('Message $index'),
          ),
        );
      },
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Handle sending message
            },
          ),
        ],
      ),
    );
  }
}
