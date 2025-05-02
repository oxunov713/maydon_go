import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/user/bloc/quizzes_cubit/quizzes_cubit.dart';
import 'package:maydon_go/src/common/model/quiz_model.dart';

import '../../../bloc/quizzes_cubit/quizzes_state.dart';

class QuizDetailPage extends StatelessWidget {
  final int quizPackId;
  final String packName;

  const QuizDetailPage(
      {super.key, required this.quizPackId, required this.packName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QuizPackCubit()..loadQuizPack(quizPackId: quizPackId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(packName),
          backgroundColor: AppColors.blue,
        ),
        backgroundColor: AppColors.white,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/champions.jpg"),
            ),
          ),
          child: BlocBuilder<QuizPackCubit, QuizzesState>(
            builder: (context, state) {
              if (state is QuizzesLoading || state is QuizPackLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QuizPackLoaded) {
                return _QuizOverview(quizPack: state.quizPack);
              } else if (state is QuizInProgress) {
                return _QuizQuestionScreen(state: state);
              } else if (state is QuizFinished) {
                return _QuizResultScreen(state: state);
              } else if (state is QuizzesError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("Failed to load quiz"));
            },
          ),
        ),
      ),
    );
  }
}

class _QuizOverview extends StatelessWidget {
  final QuizPack quizPack;

  const _QuizOverview({required this.quizPack});

  @override
  Widget build(BuildContext context) {
    final multiplier = _getMultiplierForDifficulty(quizPack.difficultyLevel);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    // Opacity bilan qora fon
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        quizPack.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${quizPack.quizzes.length} questions",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _DifficultyBadge(difficulty: quizPack.difficultyLevel),
                      const SizedBox(height: 32),
                      Text(
                        "Potential reward: ${(quizPack.quizzes.length * multiplier).toInt()} coins",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            ElevatedButton(
              onPressed: () => context.read<QuizPackCubit>().startQuiz(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Start Quiz",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMultiplierForDifficulty(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return 1.0;
      case 'medium':
        return 1.5;
      case 'hard':
        return 2.0;
      default:
        return 1.5;
    }
  }
}

class _QuizQuestionScreen extends StatelessWidget {
  final QuizInProgress state;

  const _QuizQuestionScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    final quiz = state.currentQuiz;
    final totalQuestions = state.quizPack.quizzes.length;
    final currentQuestionNumber = state.currentQuestionIndex + 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question $currentQuestionNumber/$totalQuestions",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(state.quizPack.difficultyLevel)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.quizPack.difficultyLevel?.toUpperCase() ?? 'MEDIUM',
                  style: TextStyle(
                    color: _getDifficultyColor(state.quizPack.difficultyLevel),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Timer and progress bar
          Column(
            children: [
              LinearProgressIndicator(
                value: state.timeLeft / state.totalTime,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getTimerColor(state.timeLeft / state.totalTime),
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                "${(state.timeLeft ~/ 1000)} seconds",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Question text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Text(
              quiz.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 150),
          // Answer options
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: quiz.answers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final answer = quiz.answers[index];
                return _buildAnswerOption(
                    context, answer, state.selectedAnswer);
              },
            ),
          ),

          // Next button
          ElevatedButton(
            onPressed: state.selectedAnswer != null
                ? () {
                    context
                        .read<QuizPackCubit>()
                        .moveToNextQuestion(state.quizPack);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: state.selectedAnswer != null
                  ? AppColors.green
                  : Colors.grey.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              // Kichikroq bo'ldi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              currentQuestionNumber == totalQuestions
                  ? "Finish Quiz"
                  : "Next Question",
              style: const TextStyle(
                fontSize: 16, // 18 emas, 16 qildim
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(
    BuildContext context,
    Answer answer,
    Answer? selectedAnswer,
  ) {
    bool isSelected = selectedAnswer != null &&
        answer.answerText == selectedAnswer.answerText;
    bool isCorrect = answer.correct;

    Color backgroundColor = Colors.blue.withOpacity(0.7);
    Color borderColor = Colors.blue.withOpacity(0.9);
    IconData? iconData;
    Color iconColor = Colors.transparent;

    // Only apply special styling if an answer has been selected
    if (selectedAnswer != null) {
      if (isSelected) {
        backgroundColor = isCorrect
            ? Colors.green.withOpacity(0.7)
            : Colors.red.withOpacity(0.7);
        borderColor = isCorrect ? Colors.green : Colors.red;
        iconData = isCorrect ? Icons.check_circle : Icons.cancel;
        iconColor = Colors.white;
      }
      // Do not style the correct answer unless it was selected
    }

    return GestureDetector(
      onTap: selectedAnswer == null
          ? () => context.read<QuizPackCubit>().selectAnswer(answer)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            if (selectedAnswer == null)
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                answer.answerText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              iconData,
              color: iconColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTimerColor(double progress) {
    if (progress > 0.5) return Colors.green;
    if (progress > 0.25) return Colors.orange;
    return Colors.red;
  }

  Color _getDifficultyColor(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class _QuizResultScreen extends StatelessWidget {
  final QuizFinished state;

  const _QuizResultScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    final coinsEarned =
        (state.correctAnswers * state.difficultyMultiplier * 5).toInt();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz Completed!",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "Your Score",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${state.correctAnswers} / ${state.totalQuestions}",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "+$coinsEarned coins",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                "Back to Quizzes",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String? difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = _getDifficultyColor(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        (difficulty ?? 'MEDIUM').toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
