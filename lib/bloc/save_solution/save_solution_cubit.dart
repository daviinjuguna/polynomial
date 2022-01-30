import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:polynomial/model/question.dart';
import 'package:polynomial/repo/repo.dart';

part 'save_solution_state.dart';

@injectable
class SaveSolutionCubit extends Cubit<SaveSolutionState> {
  final Repository _repo;
  SaveSolutionCubit(this._repo) : super(SaveSolutionState());

  void saveSolution(QuestionModel model) async {
    emit(state.copyWith(status: SaveStatus.loading));
    final _res = await _repo.saveSolution(model);
    emit(_res.fold(
      (l) => state.copyWith(status: SaveStatus.error, error: l),
      (r) => state.copyWith(status: SaveStatus.success, message: "Saved"),
    ));
  }
}
