import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polynomial/bloc/splash/splash_cubit.dart';
import 'package:polynomial/routes/page_transition.dart';
import 'package:polynomial/routes/routes.dart';
import 'package:polynomial/ui/auth/auth_page.dart';
import 'package:polynomial/ui/home/home_page.dart';
import 'package:polynomial/utils/simple_bloc_observer.dart';
import 'package:polynomial/utils/size_config.dart';

import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(environment: Env.dev);
  await Firebase.initializeApp();

  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _navKey = GlobalKey<NavigatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => getIt<SplashCubit>()..checkAuthUse())
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashCubit, SplashState>(
            listener: (context, state) {
              switch (state.status) {
                case SplashStatus.initial:
                case SplashStatus.loading:
                  _scaffoldKey.currentState?.hideCurrentSnackBar();
                  break;
                case SplashStatus.loggedIn:
                  _navKey.currentState?.pushNamedAndRemoveUntil(
                      HomePage.route, (route) => false);
                  break;
                case SplashStatus.loggedOut:
                  _navKey.currentState?.pushNamedAndRemoveUntil(
                      AuthPage.route, (route) => false);
                  break;
                case SplashStatus.error:
                  _scaffoldKey.currentState
                    ?..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.fixed,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Error",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                            // SizedBox(height: 3),
                            Text(
                              state.error ?? "",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError),
                            )
                          ],
                        ),
                      ),
                    );

                  break;
              }
            },
          )
        ],
        child: MaterialApp(
          navigatorKey: _navKey,
          scaffoldMessengerKey: _scaffoldKey,
          title: 'Polynomial',
          builder: (_, child) {
            SizeConfig.instance.init(_);
            return child!;
          },
          onGenerateRoute: Routes.generateRoute,
          onUnknownRoute: Routes.errorRoute,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomFadePageTransitionsBuilder()
              },
            ),
          ),
        ),
      ),
    );
  }
}
