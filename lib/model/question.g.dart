// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      userId: json['user_id'] as String? ?? "",
      question: json['question'] as String,
      xValue: json['x_value'] as String,
      answ: json['answ'] as String,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'question': instance.question,
      'x_value': instance.xValue,
      'answ': instance.answ,
    };
