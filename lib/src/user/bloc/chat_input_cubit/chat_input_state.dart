// --- States ---
abstract class ChatInputState {}

class ChatInputInitial extends ChatInputState {
  final String messageText;
  final bool isRecording;
  final bool isRecordingLocked;
  final Duration recordingDuration;
  final bool showCancelButton;

  ChatInputInitial({
    this.messageText = '',
    this.isRecording = false,
    this.isRecordingLocked = false,
    this.recordingDuration = Duration.zero,
    this.showCancelButton = false,
  });

  ChatInputInitial copyWith({
    String? messageText,
    bool? isRecording,
    bool? isRecordingLocked,
    Duration? recordingDuration,
    bool? showCancelButton,
  }) {
    return ChatInputInitial(
      messageText: messageText ?? this.messageText,
      isRecording: isRecording ?? this.isRecording,
      isRecordingLocked: isRecordingLocked ?? this.isRecordingLocked,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      showCancelButton: showCancelButton ?? this.showCancelButton,
    );
  }
}