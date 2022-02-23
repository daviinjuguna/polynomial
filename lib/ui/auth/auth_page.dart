import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polynomial/bloc/auth/auth_cubit.dart';
import 'package:polynomial/di/injection.dart';
import 'package:polynomial/ui/home/home_page.dart';
import 'package:polynomial/utils/constants.dart';
import 'package:polynomial/utils/size_config.dart';
import 'package:polynomial/utils/snackbar_widget.dart';
import 'package:polynomial/utils/spacer.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const route = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  late final _formKey = GlobalKey<FormState>();
  late final _authCubit = getIt<AuthCubit>();

  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthStatus.initial:
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              break;
            case AuthStatus.loading:
              SnackBarWidget.loadingSnackBar(context);
              break;
            case AuthStatus.loaded:
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(HomePage.route, (route) => false);
              break;
            case AuthStatus.error:
              SnackBarWidget.errorSnackBar(context, state.error ?? "");
              break;
          }
        },
        child: Scaffold(
          body: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: [
                  Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  VSpacer(space: 3),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    validator: (value) {
                      if (!RegExp(EMAIL_REGEX).hasMatch(value!))
                        return "Email is invalid";
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                    ),
                  ),
                  VSpacer(space: 2),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _isHidden,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (!RegExp(PASS_REGEX).hasMatch(value!))
                        return "Password is min 4 alphanumerical";
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _isHidden = !_isHidden);
                        },
                        icon: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  VSpacer(space: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        minWidth: SizeConfig.screenWidth * 0.45,
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            _authCubit.signUp(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Text("SIGN UP"),
                      ),
                      MaterialButton(
                        minWidth: SizeConfig.screenWidth * 0.45,
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            _authCubit.signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
