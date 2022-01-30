import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class QuestionModel {
  final String userId;
  final String question;
  final String xValue;
  final String answ;

  factory QuestionModel.fromJson(Map<String, dynamic> data) =>
      _$QuestionModelFromJson(data);
  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) =>
      QuestionModel.fromJson(doc.data() as Map<String, dynamic>);
  // .copyWith(id: doc.id);

  QuestionModel({
    this.userId = "",
    required this.question,
    required this.xValue,
    required this.answ,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionModel &&
        other.userId == userId &&
        other.question == question &&
        other.xValue == xValue &&
        other.answ == answ;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        question.hashCode ^
        xValue.hashCode ^
        answ.hashCode;
  }

  @override
  String toString() {
    return 'QuestionModel(userId: $userId, question: $question, xValue: $xValue, answ: $answ)';
  }

  QuestionModel copyWith({
    String? userId,
    String? question,
    String? xValue,
    String? answ,
  }) {
    return QuestionModel(
      userId: userId ?? this.userId,
      question: question ?? this.question,
      xValue: xValue ?? this.xValue,
      answ: answ ?? this.answ,
    );
  }
}
