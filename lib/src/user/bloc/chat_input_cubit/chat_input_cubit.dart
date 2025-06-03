

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat_input_state.dart';

class ChatInputCubit extends Cubit<ChatInputInitial> {
  final Function(String message) onSendTextMessage;
  final Function(String audioPath) onSendVoiceMessage;

  FlutterSoundRecorder? _audioRecorder;
  String? _recordingPath;
  Timer? _recordingTimer;

  ChatInputCubit({
    required this.onSendTextMessage,
    required this.onSendVoiceMessage,
  }) : super(ChatInputInitial()) {
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
  }

  void updateMessageText(String text) {
    emit(state.copyWith(messageText: text));
  }

  Future<void> startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (!status.isGranted) return;

      emit(state.copyWith(
        isRecording: true,
        recordingDuration: Duration.zero,
        showCancelButton: false,
        isRecordingLocked: false,
      ));

      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder!.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );
      _recordingPath = path;

      _recordingTimer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
            emit(state.copyWith(
                recordingDuration: state.recordingDuration + const Duration(milliseconds: 100)));
          });
    } catch (e) {
      print('Error starting recording: $e');
      emit(state.copyWith(isRecording: false));
    }
  }

  Future<void> stopRecording({bool send = true}) async {
    try {
      if (!state.isRecording) return;

      await _audioRecorder!.stopRecorder();
      _recordingTimer?.cancel();

      if (send && _recordingPath != null && !state.showCancelButton) {
        onSendVoiceMessage(_recordingPath!);
      }

      emit(state.copyWith(
        isRecording: false,
        isRecordingLocked: false,
        recordingDuration: Duration.zero,
        showCancelButton: false,
      ));
      _recordingPath = null;
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  void cancelRecording() {
    stopRecording(send: false);
    emit(state.copyWith(showCancelButton: false));
  }

  void lockRecording() {
    emit(state.copyWith(isRecordingLocked: true));
  }

  void updateCancelButtonVisibility(bool show) {
    emit(state.copyWith(showCancelButton: show));
  }

  void sendTextMessage() {
    if (state.messageText.trim().isNotEmpty) {
      onSendTextMessage(state.messageText.trim());
      emit(state.copyWith(messageText: '',)); // Clear text after sending
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Future<void> close() {
    _audioRecorder?.closeRecorder();
    _recordingTimer?.cancel();
    return super.close();
  }
}