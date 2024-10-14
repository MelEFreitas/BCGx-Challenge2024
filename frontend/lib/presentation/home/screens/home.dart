import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/update_user/update_user_cubit.dart';
import 'package:frontend/presentation/home/widgtes/chat_display.dart';
import 'package:frontend/presentation/home/widgtes/chat_history.dart';
import 'package:frontend/presentation/home/widgtes/chat_input.dart';

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
                            context.read<GetChatCubit>().resetChat();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: ChatHistory()),
                ],
              ),
            )
          : null,
      appBar: MediaQuery.of(context).size.width < 600
          ? AppBar(
              title: const Text('GenAI Chat'),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Now this works!
                    },
                  );
                },
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings), // Three horizontal dots
                  onSelected: (value) {
                    if (value == 'sign_out') {
                      _showSignOutDialog(context);
                    }
                    else if (value == 'change_role') {
                      _showChangeRoleDialog(context);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'sign_out',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'change_role',
                        child: Row(
                          children: [
                            Icon(Icons.settings, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Change Role',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 600)
            SizedBox(
              width: 300,
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
                            context.read<GetChatCubit>().resetChat();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: ChatHistory()),
                ],
              ),
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      if (MediaQuery.of(context).size.width >= 600)
                        Container(
                          color: Colors.grey[200],
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
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
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.settings), // Three horizontal dots
                                onSelected: (value) {
                                  if (value == 'sign_out') {
                                    _showSignOutDialog(context);
                                  }
                                  else if (value == 'change_role') {
                                    _showChangeRoleDialog(context);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'sign_out',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text(
                                            'Sign Out',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'change_role',
                                      child: Row(
                                        children: [
                                          Icon(Icons.settings, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text(
                                            'Change Role',
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
                      const Expanded(
                        child: ChatDisplay(),
                      ),
                      const ChatInputField(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Handle the deletion of the chat
                await context.read<AuthCubit>().signOut();
                if (context.mounted) context.read<GetChatCubit>().resetChat();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showChangeRoleDialog(BuildContext context) {
    // Fetch the current role from the AuthCubit state
    final authState = context.read<AuthCubit>().state;
    String currentRole = '';

    if (authState is AuthStateAuthenticated) {
      currentRole = authState.user.role; // Get current role from state
    }

    // Define the roles
    final roles = [
      {"title": "Admin", "description": "Full access to the system"},
      {"title": "Editor", "description": "Can edit and manage content"},
      {"title": "Viewer", "description": "Can only view content"},
    ];

    // Find the index of the current role
    int selectedRoleIndex = roles.indexWhere((role) => role['title'] == currentRole);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Role'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select your new role:'),
                const SizedBox(height: 10),
                // Create the role selection boxes
                ...roles.asMap().entries.map((entry) {
                  int index = entry.key;
                  String roleTitle = entry.value["title"]!;
                  String roleDescription = entry.value["description"]!;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        selectedRoleIndex = index; // Update the selected index
                        // Use setState-like mechanism to rebuild the dialog
                        (context as Element).markNeedsBuild();
                      },
                      child: Container(
                        width: double.infinity, // Make the box take full width
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: selectedRoleIndex == index
                              ? Colors.blue.shade100
                              : Colors.grey.shade200,
                          border: Border.all(
                            color: selectedRoleIndex == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roleTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(roleDescription),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Handle the role submission
                String newRole = roles[selectedRoleIndex]['title']!;
                await context.read<UpdateUserCubit>().updateUser(newRole);
                if(context.mounted) await context.read<AuthCubit>().authenticateUser();
                if(context.mounted) Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }


}
