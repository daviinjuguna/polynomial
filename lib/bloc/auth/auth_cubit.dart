import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:polynomial/repo/repo.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final Repository _repo;

  AuthCubit(this._repo) : super(AuthState());

  void signUp({required String email, required String password}) => _action(
      _repo.createUserWithEmailAndPassword(email: email, password: password));

  void signIn({required String email, required String password}) => _action(
      _repo.signUserWithEmailAndPassword(email: email, password: password));

  void _action(Future<Either<String, Unit>> forwadedCall) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final _res = await forwadedCall;
    emit(_res.fold(
      (l) => state.copyWith(status: AuthStatus.error, error: l),
      (r) => state.copyWith(status: AuthStatus.loaded),
    ));
  }
}
