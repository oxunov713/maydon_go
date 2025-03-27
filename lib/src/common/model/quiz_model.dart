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
