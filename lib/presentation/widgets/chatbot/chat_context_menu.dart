import 'package:flutter/material.dart';

enum ChatMenuAction { copy, edit, delete }

Future<ChatMenuAction?> showChatContextMenu({
  required BuildContext context,
  required Offset tapPosition,
  required List<ChatMenuAction> actions,
}) {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  return showMenu<ChatMenuAction>(
    context: context,
    position: RelativeRect.fromRect(
      tapPosition & const Size(40, 40),
      Offset.zero & overlay.size,
    ),
    items: [
      if (actions.contains(ChatMenuAction.copy))
        const PopupMenuItem<ChatMenuAction>(
          value: ChatMenuAction.copy,
          child: Row(
            children: [
              Icon(Icons.copy_outlined, size: 20),
              SizedBox(width: 8),
              Text('Copy'),
            ],
          ),
        ),
      if (actions.contains(ChatMenuAction.edit))
        const PopupMenuItem<ChatMenuAction>(
          value: ChatMenuAction.edit,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 8),
              Text('Edit Message'),
            ],
          ),
        ),
      if (actions.contains(ChatMenuAction.delete))
        const PopupMenuItem<ChatMenuAction>(
          value: ChatMenuAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
    ],
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  );
}