import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polynomial/bloc/poly/poly_cubit.dart';
import 'package:polynomial/bloc/save_solution/save_solution_cubit.dart';
import 'package:polynomial/bloc/splash/splash_cubit.dart';
import 'package:polynomial/bloc/watch_solution/watch_solution_bloc.dart';
import 'package:polynomial/di/injection.dart';
import 'package:polynomial/model/question.dart';
import 'package:polynomial/utils/size_config.dart';
import 'package:polynomial/utils/snackbar_widget.dart';
import 'package:polynomial/utils/spacer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _polyCubit = getIt<PolyCubit>();
  late final _saveSolution = getIt<SaveSolutionCubit>();
  late final _watchBloc = getIt<WatchSolutionBloc>();

  TextEditingController _eqController = TextEditingController();
  TextEditingController _valController = TextEditingController();
  String? _answer = '';

  List<QuestionModel> _questions = [];

  @override
  void initState() {
    super.initState();
    _watchBloc.add(StreamSolutionEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _eqController.dispose();
    _valController.dispose();
    _polyCubit.close();
    _saveSolution.close();
    _watchBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _polyCubit),
        BlocProvider(create: (create) => _saveSolution),
        BlocProvider(create: (create) => _watchBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SaveSolutionCubit, SaveSolutionState>(
            listener: (context, state) {
              switch (state.status) {
                case SaveStatus.initial:
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  break;
                case SaveStatus.loading:
                  SnackBarWidget.loadingSnackBar(context);
                  break;
                case SaveStatus.success:
                  SnackBarWidget.successSnackBar(
                      context, state.message ?? "Saved");
                  break;
                case SaveStatus.error:
                  SnackBarWidget.errorSnackBar(context, state.error ?? "");
                  break;
              }
            },
          ),
          BlocListener<WatchSolutionBloc, WatchSolutionState>(
            listener: (context, state) {
              switch (state.status) {
                case WatchStatus.initial:
                  break;
                case WatchStatus.loading:
                  break;
                case WatchStatus.success:
                  _questions = state.model;
                  break;
                case WatchStatus.error:
                  break;
              }
            },
          ),
          BlocListener<PolyCubit, PolyState>(
            listener: (context, state) {
              switch (state.status) {
                case PolyStatus.initial:
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  break;
                case PolyStatus.loading:
                  // SnackBarWidget.loadingSnackBar(context);
                  break;
                case PolyStatus.error:
                  SnackBarWidget.errorSnackBar(context, state.error ?? "");
                  break;
                case PolyStatus.success:
                  _answer = state.result?.toString() ?? "";
                  SnackBarWidget.successSnackBar(context, "Solved");
                  break;
              }
            },
          )
        ],
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VSpacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      BlocProvider.of<SplashCubit>(context).logout();
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text("Logout"),
                  ),
                ),
                VSpacer(space: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      "assets/polynomial.svg",
                      height: SizeConfig.blockSizeVertical * 10,
                    ),
                    Text(
                      "Polynomial",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                    )
                  ],
                ),
                VSpacer(space: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "f(x) = ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text: "ax^b",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                VSpacer(space: 2),
                TextFormField(
                  controller: _eqController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Enter equation in form of  ax^b",
                  ),
                ),
                VSpacer(space: 2),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _valController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Enter the value of x",
                  ),
                ),
                VSpacer(space: 2),
                BlocBuilder<PolyCubit, PolyState>(
                  builder: (context, state) {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Derivative = ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextSpan(
                            text: _answer,
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    );
                  },
                ),
                VSpacer(space: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        if (!_eqController.text.contains("x")) {
                          SnackBarWidget.errorSnackBar(
                              context, "Enter equation in form of  ax^b");
                          return;
                        }
                        if (_valController.text.isEmpty ||
                            double.tryParse(_valController.text.trim()) ==
                                null) {
                          SnackBarWidget.errorSnackBar(
                              context, "Value of x should be numeric");
                          return;
                        }

                        _polyCubit.getDerivative(
                          question: _eqController.text,
                          value: int.parse(_valController.text),
                        );
                      },
                      child: Text("Solve"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (_answer != null && _answer!.isEmpty) {
                          SnackBarWidget.errorSnackBar(
                              context, "Answer is empty");
                          return;
                        }
                        _saveSolution.saveSolution(QuestionModel(
                          question: _eqController.text,
                          xValue: _valController.text,
                          answ: _answer!,
                        ));
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
                VSpacer(space: 5),
                Text(
                  "History",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                BlocBuilder<WatchSolutionBloc, WatchSolutionState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case WatchStatus.initial:
                        break;
                      case WatchStatus.loading:
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      case WatchStatus.success:
                        if (state.model.isEmpty)
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("You have no istory"),
                            ),
                          );
                        break;
                      case WatchStatus.error:
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                              onPressed: () {
                                _watchBloc.add(StreamSolutionEvent());
                              },
                              child: Text("RETRY"),
                            ),
                          ),
                        );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _questions.length,
                      itemBuilder: (_, i) {
                        final _model = _questions[i];
                        return Card(
                          child: ListTile(
                            title: Text(_model.question),
                            subtitle: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Derivative = ",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _model.answ,
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            trailing: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Value of x = ",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _model.xValue,
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
