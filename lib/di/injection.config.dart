// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../bloc/auth/auth_cubit.dart' as _i9;
import '../bloc/poly/poly_cubit.dart' as _i10;
import '../bloc/save_solution/save_solution_cubit.dart' as _i6;
import '../bloc/splash/splash_cubit.dart' as _i7;
import '../bloc/watch_solution/watch_solution_bloc.dart' as _i8;
import '../repo/repo.dart' as _i5;
import 'module_injection.dart' as _i11; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final moduleInjection = _$ModuleInjection();
  gh.factory<_i3.FirebaseAuth>(() => moduleInjection.firebaseAuth);
  gh.factory<_i4.FirebaseFirestore>(() => moduleInjection.firestore);
  gh.lazySingleton<_i5.Repository>(() => _i5.RepositoryImpl(
      get<_i3.FirebaseAuth>(), get<_i4.FirebaseFirestore>()));
  gh.factory<_i6.SaveSolutionCubit>(
      () => _i6.SaveSolutionCubit(get<_i5.Repository>()));
  gh.factory<_i7.SplashCubit>(() => _i7.SplashCubit(get<_i5.Repository>()));
  gh.factory<_i8.WatchSolutionBloc>(
      () => _i8.WatchSolutionBloc(get<_i5.Repository>()));
  gh.factory<_i9.AuthCubit>(() => _i9.AuthCubit(get<_i5.Repository>()));
  gh.factory<_i10.PolyCubit>(() => _i10.PolyCubit(get<_i5.Repository>()));
  return get;
}

class _$ModuleInjection extends _i11.ModuleInjection {}
