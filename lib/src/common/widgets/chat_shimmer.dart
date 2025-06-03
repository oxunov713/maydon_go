import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../user/bloc/chat_cubit/chat_cubit.dart';
import '../style/app_colors.dart';

Widget buildLoadingUI() {
  return Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Loading..."),
        ],
      ),
    ),
    body: BlocBuilder<ChatCubit, ChatSState>(builder: (context, state) {
      return Stack(
        children: [
          if (state.wallpaper != null)
            Positioned.fill(
              child: Image.asset(
                state.wallpaper!,
                fit: BoxFit.cover,
              ),
            ),
          Column(
            children: [
              Material(
                color: AppColors.green40,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 15,
                            children: [
                              Container(
                                width: 4,
                                height: 30,
                                margin:
                                const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                  AppColors.shimmerHighlightColor,
                                  child: Container(
                                    width:
                                    MediaQuery.sizeOf(context).width / 2,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )),
                            ],
                          ),
                          Icon(
                            Icons.expand_more,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final isMe = index % 3 == 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Column(
                              spacing: 15,
                              children: [
                                SizedBox(),
                                Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                  AppColors.shimmerHighlightColor,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                  AppColors.shimmerHighlightColor,
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(12),
                                        topRight: const Radius.circular(12),
                                        bottomLeft:
                                        Radius.circular(isMe ? 12 : 0),
                                        bottomRight:
                                        Radius.circular(isMe ? 0 : 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}