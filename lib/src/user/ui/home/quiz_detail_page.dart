// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../common/style/app_colors.dart';
// import '../../bloc/quizzes_cubit/quizzes_cubit.dart';
// import '../../bloc/quizzes_cubit/quizzes_state.dart';
//
// class QuizzesScreen extends StatelessWidget {
//   const QuizzesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => QuizzesCubit()..loadQuizzes(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Quizzes"),
//           backgroundColor: AppColors.blue,
//         ),
//         backgroundColor: AppColors.white,
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               fit: BoxFit.cover,
//               image: AssetImage(
//                 "assets/images/champions.jpg",
//               ),
//             ),
//           ),
//           child: BlocBuilder<QuizzesCubit, QuizzesState>(
//             builder: (context, state) {
//               if (state is QuizzesLoading) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (state is QuizzesLoaded) {
//                 return _QuizBody(state: state);
//               } else if (state is QuizzesFinished) {
//                 return _QuizResult(state: state);
//               }
//               return Center(child: Text("Savollar yuklanmadi!"));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _QuizBody extends StatelessWidget {
//   final QuizzesLoaded state;
//
//   const _QuizBody({required this.state});
//
//   @override
//   Widget build(BuildContext context) {
//     final quiz = state.quizzes[state.currentIndex];
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Text(
//                 quiz.question,
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//                 textAlign: TextAlign.center,
//               ),
//               LinearProgressIndicator(
//                 value: state.timeLeft / 20000,
//                 backgroundColor: AppColors.grey4,
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.green3),
//               ),
//               Text(
//                 "Time Left: ${(state.timeLeft ~/ 1000)} s",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Column(
//                 children: quiz.options
//                     .map((option) => _buildOption(context, option))
//                     .toList(),
//               ),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: WidgetStatePropertyAll(
//                           state.isAnswerSelected
//                               ? AppColors.green
//                               : Colors.grey)),
//                   onPressed: state.isAnswerSelected
//                       ? () => context.read<QuizzesCubit>().nextQuestion()
//                       : null,
//                   child: Text(
//                     "Next",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOption(BuildContext context, String option) {
//     final isCorrect = option == state.quizzes[state.currentIndex].correctAnswer;
//     final isSelected = option == state.selectedAnswer;
//     Color cardColor;
//
//     if (state.selectedAnswer == null) {
//       cardColor = Colors.blue; // Oldingi holat
//     } else if (isSelected) {
//       cardColor = isCorrect ? Colors.green : Colors.red;
//     } else {
//       cardColor = Colors.grey; // Qolgan variantlar kulrang bo'ladi
//     }
//
//     return GestureDetector(
//       onTap: state.selectedAnswer == null
//           ? () => context.read<QuizzesCubit>().selectAnswer(option)
//           : null,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: cardColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Text(
//             option,
//             style: TextStyle(fontSize: 18, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _QuizResult extends StatelessWidget {
//   final QuizzesFinished state;
//
//   const _QuizResult({required this.state});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Test yakuni",
//             style: TextStyle(
//                 fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Sizning natijangiz:",
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//               Text(
//                 " +100 coins",
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.orange,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }