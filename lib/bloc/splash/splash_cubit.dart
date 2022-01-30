import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:polynomial/repo/repo.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final Repository _repo;

  SplashCubit(this._repo) : super(const SplashState());

  void checkAuthUse() async {
    emit(state.copyWith(status: SplashStatus.loading));
    final _res = await _repo.fetchAuthUser();
    emit(_res.fold(
      (l) => state.copyWith(status: SplashStatus.error, error: l),
      (r) {
        if (r) {
          return state.copyWith(status: SplashStatus.loggedIn);
        }
        return state.copyWith(status: SplashStatus.loggedOut);
      },
    ));
  }

  void logout() async {
    emit(state.copyWith(status: SplashStatus.loading));
    final _res = await _repo.logout();
    _res.fold(
      (l) => log(l),
      (r) => log("LOGGED OUT"),
    );
    emit(state.copyWith(status: SplashStatus.loggedOut));
  }
}
