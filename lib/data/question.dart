import 'option.dart';

class Question {
  final String id;
  final String text;
  final List<Option>? options;
  final QuestionType type;


  const Question({
    required this.id,
    required this.text,
     this.options,
    this.type = QuestionType.options,

  });
}
enum QuestionType { options, textInput }
