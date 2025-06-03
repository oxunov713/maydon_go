import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/chat_model.dart';
import 'package:maydon_go/src/user/bloc/pinned_messages/pinned_messages_state.dart';

import '../../user/bloc/pinned_messages/pinned_messages_cubit.dart';
import '../style/app_colors.dart';

class PinnedMessagesHeader extends StatelessWidget {
  final List<ChatMessage> pinnedMessages;
  final VoidCallback onClose;
  final ValueChanged<int> onPinTap;
  final PinnedMessagesCubit cubit;
  final VoidCallback onExpandToggle;

  const PinnedMessagesHeader({
    super.key,
    required this.pinnedMessages,
    required this.onClose,
    required this.onPinTap,
    required this.cubit,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinnedMessagesCubit, PinnedMessagesState>(
      bloc: cubit,
      builder: (context, state) {
        if (pinnedMessages.isEmpty) return const SizedBox();

        final activeIndex =
        state.activeIndex.clamp(0, pinnedMessages.length - 1);
        final activeMessage = pinnedMessages[activeIndex];

        return Material(
          color: AppColors.green40,
          child: Column(
            children: [
              InkWell(
                onTap: onExpandToggle,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 30,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pinned message (${activeIndex + 1}/${pinnedMessages.length})",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeMessage.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!state.isExpanded)
                        GestureDetector(
                          onTap: () {
                            cubit.toggleExpanded();
                          },
                          child: const Icon(Icons.expand_more, color: AppColors.white),
                        ),
                      if (state.isExpanded && pinnedMessages.length > 1) ...[
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: activeIndex > 0
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.3),
                          ),
                          onPressed: activeIndex > 0
                              ? () {
                            cubit.changeIndex(activeIndex - 1);
                            onPinTap(activeIndex - 1);
                          }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: activeIndex < pinnedMessages.length - 1
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.3),
                          ),
                          onPressed: activeIndex < pinnedMessages.length - 1
                              ? () {
                            cubit.changeIndex(activeIndex + 1);
                            onPinTap(activeIndex + 1);
                          }
                              : null,
                        ),
                        GestureDetector(
                          onTap: () {
                            cubit.toggleExpanded();
                          },
                          child: const Icon(Icons.expand_less, color: AppColors.white),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (state.isExpanded && pinnedMessages.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pinnedMessages.length,
                          (index) => GestureDetector(
                        onTap: () {
                          cubit.changeIndex(index);
                          onPinTap(index);
                        },
                        child: Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
