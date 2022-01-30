part of 'watch_solution_bloc.dart';

@immutable
abstract class WatchSolutionEvent {}

class StreamSolutionEvent extends WatchSolutionEvent {}

class _GetSolutionEvent extends WatchSolutionEvent {
  final Either<String, List<QuestionModel>> data;

  _GetSolutionEvent({
    required this.data,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _GetSolutionEvent && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => '_GetSolutionEvent(data: $data)';
}
