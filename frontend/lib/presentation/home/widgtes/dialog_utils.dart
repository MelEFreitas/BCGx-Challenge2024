import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/home/cubits/delete_chat/delete_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
import 'package:frontend/presentation/home/cubits/update_user/update_user_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/presentation/home/widgtes/dialog_button.dart';

void showSignOutDialog(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ThemeColors.lightGrey,
        title: Text(localizations.signOut),
        content: Text(localizations.sureSignOut),
        actions: <Widget>[
          DialogButton(label: localizations.cancel, backgroundColor: ThemeColors.darkGreen, onPressed: () async {
              Navigator.of(context).pop();
            }
          ),
          DialogButton(label: localizations.signOut, backgroundColor: Colors.red, onPressed: () async {
              await context.read<AuthCubit>().signOut();
              if (context.mounted) context.read<GetChatCubit>().resetChat();
              if (context.mounted) Navigator.of(context).pop();
            }
          )
        ],
      );
    },
  );
}

void showDeleteDialog(BuildContext context, String chatId) {
  final localizations = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ThemeColors.lightGrey,
        title: Text(localizations.deleteChat),
        content: Text(localizations.sureDeleteChat),
        actions: <Widget>[
          DialogButton(label: localizations.cancel, backgroundColor: ThemeColors.darkGreen, onPressed: () async {
              Navigator.of(context).pop();
            }
          ),
          DialogButton(label: localizations.delete, backgroundColor: Colors.red, onPressed: () async {
              await context.read<DeleteChatCubit>().deleteChat(chatId);
              if (context.mounted) context.read<GetChatCubit>().resetChat();
              if (context.mounted) {
                await context
                    .read<GetChatSummariesCubit>()
                    .getAllChatSummaries();
              }
              if (context.mounted) Navigator.of(context).pop();
            }
          )
        ],
      );
    },
  );
}

void showChangeRoleDialog(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  final authState = context.read<AuthCubit>().state;
  String currentRole = '';

  if (authState is AuthStateAuthenticated) {
    currentRole = authState.user.role;
  }

  final roles = [
    {
      "title": localizations.userTitle,
      "description": localizations.userDescription
    },
    {
      "title": localizations.managerTitle,
      "description": localizations.managerDescription
    },
    {
      "title": localizations.envAnalystTitle,
      "description": localizations.envAnalystDescription
    },
  ];

  int selectedRoleIndex =
      roles.indexWhere((role) => role['title'] == currentRole);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ThemeColors.lightGrey,
        title: Text(localizations.changeRole),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.selectNewRole),
              const SizedBox(height: 10),
              ...roles.asMap().entries.map((entry) {
                int index = entry.key;
                String roleTitle = entry.value["title"]!;
                String roleDescription = entry.value["description"]!;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      selectedRoleIndex = index;
                      (context as Element).markNeedsBuild();
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: selectedRoleIndex == index
                            ? ThemeColors.roleSelected
                            : ThemeColors.lightGrey,
                        border: Border.all(
                          color: selectedRoleIndex == index
                              ? ThemeColors.darkGreen
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
          DialogButton(label: localizations.cancel, backgroundColor: ThemeColors.darkGreen, onPressed: () async {
              Navigator.of(context).pop();
            }
          ),
          DialogButton(label: localizations.submit, backgroundColor: ThemeColors.orange, onPressed: () async {
              String newRole = roles[selectedRoleIndex]['title']!;
              await context.read<UpdateUserCubit>().updateUser(newRole);
              if (context.mounted) {
                await context.read<AuthCubit>().authenticateUser();
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          ),
        ],
      );
    },
  );
}
