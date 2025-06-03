import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart'; // Keep if you need FlutterSoundRecorder in cubit
import 'package:maydon_go/src/user/bloc/team_cubit/team_chat_cubit.dart';
import 'package:path_provider/path_provider.dart'; // Keep if you need getTemporaryDirectory in cubit
import 'package:permission_handler/permission_handler.dart'; // Keep if you need permission in cubit
import 'package:vibration/vibration.dart';

import '../../user/bloc/chat_cubit/chat_cubit.dart';
import '../../user/bloc/chat_input_cubit/chat_input_cubit.dart';
import '../../user/bloc/chat_input_cubit/chat_input_state.dart';
import '../style/app_colors.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
    required this.isPrivateChat,
  });

  final bool isPrivateChat;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController =
      ScrollController(); // Not used in this context, can be removed if not used elsewhere

  OverlayEntry? _overlayEntry;
  Timer? _infoTooltipTimer;

  @override
  void initState() {
    super.initState();
    // Listen to changes in the Cubit's state to update the text controller
    context.read<ChatInputCubit>().stream.listen((state) {
      if (_textController.text != state.messageText) {
        _textController.text = state.messageText;
        _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length));
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose(); // Dispose if kept
    _hideInfoWindow(); // Ensure overlay is hidden on dispose
    super.dispose();
  }

  void _showInfoWindow() {
    if (_overlayEntry != null) return;

    Vibration.vibrate(duration: 50);

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: offset.dx + 30,
        top: offset.dy - 90,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Ovozli xabar yuborish uchun\nuzoqroq bosib turing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Icon(Icons.arrow_drop_up, color: Colors.black.withOpacity(0.7)),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _infoTooltipTimer = Timer(const Duration(seconds: 3), () {
      _hideInfoWindow();
    });
  }

  void _hideInfoWindow() {
    _infoTooltipTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatInputCubit(
        onSendTextMessage: (message) {
          widget.isPrivateChat
              ? context.read<ChatCubit>().sendMessage(message)
              : context.read<TeamChatCubit>().sendMessage(message);
          _textController.clear();
        },
        onSendVoiceMessage: (audioPath) {
          // You'll need to add a method to your ChatCubit/TeamChatCubit for sending voice messages
          // For example:
          // widget.isPrivateChat
          //     ? context.read<ChatCubit>().sendVoiceMessage(audioPath)
          //     : context.read<TeamChatCubit>().sendVoiceMessage(audioPath);
        },
      ),
      child: BlocBuilder<ChatInputCubit, ChatInputInitial>(
        builder: (context, state) {
          final chatInputCubit = context.read<ChatInputCubit>();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.isRecording && state.isRecordingLocked)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mic, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          chatInputCubit
                              .formatDuration(state.recordingDuration),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => chatInputCubit.stopRecording(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'SEND',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state.isRecording && !state.isRecordingLocked
                            ? Container(
                                key: const ValueKey('recording'),
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.mic, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(
                                      chatInputCubit.formatDuration(
                                          state.recordingDuration),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                key: const ValueKey('textField'),
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: _textController,
                                  focusNode: _messageFocusNode,
                                  decoration: const InputDecoration(
                                    hintText: 'Type a message...',
                                    border: InputBorder.none,
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) =>
                                      chatInputCubit.updateMessageText(value),
                                  onSubmitted: (_) =>
                                      chatInputCubit.sendTextMessage(),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(context, state, chatInputCubit),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, ChatInputInitial state, ChatInputCubit cubit) {
    final isTextEmpty = state.messageText.trim().isEmpty;

    if (isTextEmpty || state.isRecording) {
      return GestureDetector(
        onLongPressStart: (_) => cubit.startRecording(),
        onLongPressMoveUpdate: (details) {
          if (!state.isRecording) return;
          final screenWidth = MediaQuery.of(context).size.width;
          final dx = details.globalPosition.dx;
          cubit.updateCancelButtonVisibility(dx < screenWidth * 0.3);
        },
        onLongPressEnd: (details) {
          if (!state.isRecordingLocked) {
            cubit.stopRecording(send: !state.showCancelButton);
          }
        },
        onTap: () {
          if (!isTextEmpty) {
            cubit.sendTextMessage();
            _textController.clear();
          } else {
            _showInfoWindow();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: state.isRecording ? Colors.red : AppColors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            state.isRecording ? Icons.mic : Icons.mic_none,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.send, color: AppColors.green),
        onPressed: cubit.sendTextMessage,
      );
    }
  }
}
