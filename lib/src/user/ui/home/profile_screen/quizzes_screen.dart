import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

import '../../../../common/model/quiz_model.dart';
import '../../../bloc/quizzes_cubit/quizzes_cubit.dart';
import '../../../bloc/quizzes_cubit/quizzes_state.dart';

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizPackCubit()..fetchQuizzes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Quizzes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<QuizPackCubit, QuizzesState>(
            builder: (context, state) {
              if (state is QuizzesLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(AppColors.blue),
                  ),
                );
              }

              if (state is QuizzesError) {
                return ErrorWidget(
                  error: (state as QuizzesError).message,
                  onRetry: () => context.read<QuizPackCubit>().fetchQuizzes(),
                );
              }

              if (state is QuizzesLoaded &&
                  (state as QuizzesLoaded).quizPacks.isEmpty) {
                return EmptyStateWidget(
                  onRefresh: () => context.read<QuizPackCubit>().fetchQuizzes(),
                );
              }

              if (state is QuizzesLoaded) {
                final quizPacks = (state as QuizzesLoaded).quizPacks;

                return RefreshIndicator(
                  color: AppColors.blue,
                  onRefresh: () async {
                    await context.read<QuizPackCubit>().fetchQuizzes();
                  },
                  child: AnimatedListSwitcher(
                    children: [
                      ListView.separated(
                        key: const ValueKey('quizzes-list'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: quizPacks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final quiz = quizPacks[index];
                          return QuizCard(
                            quiz: quiz,
                            onTap: () {
                              context.pushNamed(AppRoutes.quizDetail, extra: {
                                "quizId": quiz.id,
                                "packName": quiz.name
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: Text("Unknown state"));
            },
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final QuizPack quiz;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.white2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      quiz.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DifficultyBadge(difficulty: quiz.difficultyLevel ?? "Easy"),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${quiz.quizzes.length} questions",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  Color get _color {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(
              color: Colors.red.shade400,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Retry",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyStateWidget({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            "No quizzes available",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRefresh,
            child: const Text(
              "Refresh",
              style: TextStyle(color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedListSwitcher extends StatelessWidget {
  final List<Widget> children;

  const AnimatedListSwitcher({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: children.first,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical,
            child: child,
          ),
        );
      },
    );
  }
}
