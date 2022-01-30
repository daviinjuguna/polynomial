import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@injectableInit

///initializing service locator for the app
Future<void> configureInjection({String? environment}) async =>
    await $initGetIt(getIt, environment: environment);

///Environments for service locator [dev] for development [prod] for production
abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}
