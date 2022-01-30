import 'package:flutter/material.dart';
import 'package:polynomial/utils/spacer.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "An error Occurred",
            style: Theme.of(context).textTheme.headline6,
          ),
          const VSpacer(space: 5),
          Text(
            "This page is not available",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const VSpacer(space: 3),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.exit_to_app),
            label: Text("GO BACK"),
          )
        ],
      ),
      // body: BigTip(
      //   title: Text('An error ocurred'),
      //   subtitle: Text('This page is not available'),
      //   action: Text('GO BACK'),
      //   actionCallback: () => Navigator.pop(context),
      //   child: Icon(Icons.error_outline),
      // ),
    );
  }
}
