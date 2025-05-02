class Answer {
  final int id;
  final String answerText;
  final bool correct;

  Answer({
    required this.id,
    required this.answerText,
    required this.correct,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answerText: json['answerText'],
      correct: json['correct'],
    );
  }
}

class Quiz {
  final int id;
  final String questionText;
  final List<Answer> answers;

  Quiz({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      questionText: json['questionText'],
      answers: (json['answers'] as List)
          .map((answer) => Answer.fromJson(answer))
          .toList(),
    );
  }
}

class QuizPack {
  final int id;
  final String name;
  final String? difficultyLevel;
  final List<Quiz> quizzes;

  QuizPack({
    required this.id,
    required this.name,
    this.difficultyLevel,
    required this.quizzes,
  });

  factory QuizPack.fromJson(Map<String, dynamic> json) {
    return QuizPack(
      id: json['id'] as int,
      name: json['name'] as String,
      difficultyLevel: json['difficultyLevel'] as String?,
      quizzes: (json['quizzes'] as List?)
              ?.map((quizJson) => Quiz.fromJson(quizJson))
              .toList() ??
          [],
    );
  }
}
