import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:polynomial/repo/repo.dart';

part 'poly_state.dart';

@injectable
class PolyCubit extends Cubit<PolyState> {
  final Repository _repo;
  PolyCubit(this._repo) : super(PolyState());

  void getDerivative({required String question, required int value}) async {
    emit(state.copyWith(status: PolyStatus.loading));
    final _res = await _repo.solve(question: question, value: value);
    emit(_res.fold(
      (l) => state.copyWith(status: PolyStatus.error, error: l),
      (r) => state.copyWith(status: PolyStatus.success, result: r),
    ));
  }
}
