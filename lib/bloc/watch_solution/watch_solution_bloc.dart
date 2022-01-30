import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:polynomial/model/question.dart';
import 'package:polynomial/repo/repo.dart';

part 'watch_solution_event.dart';
part 'watch_solution_state.dart';

@injectable
class WatchSolutionBloc extends Bloc<WatchSolutionEvent, WatchSolutionState> {
  WatchSolutionBloc(Repository _repo) : super(WatchSolutionState()) {
    on<StreamSolutionEvent>((event, emit) async {
      await emit.onEach<Either<String, List<QuestionModel>>>(
        _repo.watchQuestions(),
        onData: (data) => add(_GetSolutionEvent(data: data)),
        onError: (obj, stack) {
          print(obj);
          print(stack);
          emit(
            state.copyWith(
              status: WatchStatus.error,
              error: obj.toString(),
            ),
          );
        },
      );
    });
    on<_GetSolutionEvent>(
      (event, emit) => emit(
        event.data.fold(
          (l) => state.copyWith(status: WatchStatus.error, error: l),
          (r) => state.copyWith(status: WatchStatus.success, model: r),
        ),
      ),
    );
  }
}
