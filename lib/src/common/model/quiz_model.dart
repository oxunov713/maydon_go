class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  bool isCorrect(String answer) => answer == correctAnswer;
}

List<QuizQuestion> $footballQuizzes = [
  QuizQuestion(
    question: "Qaysi jamoa eng ko‘p FIFA Jahon chempionatida g‘alaba qozongan?",
    options: ["Argentina", "Braziliya", "Germaniya", "Fransiya"],
    correctAnswer: "Braziliya",
  ),
  QuizQuestion(
    question: "FIFA Jahon chempionati qaysi yildan beri o‘tkaziladi?",
    options: ["1928", "1930", "1942", "1950"],
    correctAnswer: "1930",
  ),
  QuizQuestion(
    question: "Messi qaysi klub bilan 2021-yilda shartnoma imzoladi?",
    options: ["Barcelona", "PSG", "Man City", "Juventus"],
    correctAnswer: "PSG",
  ),
  QuizQuestion(
    question: "Qaysi futbolchi eng ko‘p Ballon d'Or mukofotini yutgan?",
    options: ["Cristiano Ronaldo", "Lionel Messi", "Pelé", "Maradona"],
    correctAnswer: "Lionel Messi",
  ),
  QuizQuestion(
    question: "Futbol maydoni uzunligi qancha bo‘lishi kerak?",
    options: ["90-120 m", "100-130 m", "110-140 m", "80-110 m"],
    correctAnswer: "90-120 m",
  ),
];
