import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

import '../model/chat_model.dart';

typedef VoidCallbackAction = Future<void> Function();

Future<void> showMessageOptions({
  required BuildContext context,
  required ChatMessage message,
  required Offset offset,
  required String currentUserId,
  required List<ChatMessage> pinnedMessages,
  required VoidCallbackAction deleteFunction,
  required VoidCallbackAction pinFunction,
  required VoidCallbackAction unpinFunction,
  required VoidCallbackAction forwardFunction,
}) async {
  FocusScope.of(context).unfocus();

  final isOwnMessage = message.senderId.toString() == currentUserId;
  final isPinned = pinnedMessages.any((m) => m.id == message.id);

  final selected = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx + 50,
      offset.dy,
      offset.dx + 100,
      offset.dy,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    elevation: 8,
    items: [
      PopupMenuItem<String>(
        value: 'pin',
        child: Row(
          children: [
            Icon(
              isPinned ? Icons.push_pin_outlined : Icons.push_pin,
              size: 20,
              color: isPinned ? AppColors.red : null,
            ),
            const SizedBox(width: 10),
            Text(
              isPinned ? "Unpin qilish" : "Pin qilish",
              style: TextStyle(color: isPinned ? AppColors.red : null),
            ),
          ],
        ),
      ),

      const PopupMenuItem<String>(
        value: 'copy',
        child: Row(
          children: [
            Icon(Icons.copy, size: 20),
            SizedBox(width: 10),
            Text("Nusxa olish"),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'forward',
        child: Row(
          children: [
            Icon(Icons.send, size: 20),
            SizedBox(width: 10),
            Text("Jo'natish"),
          ],
        ),
      ),
      if (isOwnMessage)
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 10),
              Text("O‘chirish", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
    ],
  );

  if (!context.mounted || selected == null) return;
  FocusScope.of(context).unfocus();
  switch (selected) {
    case 'pin':
      if (isPinned) {
        await unpinFunction();
      } else {
        await pinFunction();
      }
      break;
    case 'copy':
      Clipboard.setData(ClipboardData(text: message.content));
      break;
    case 'forward':
      await forwardFunction();
      break;
    case 'delete':
      await deleteFunction();
      break;

  }

}
