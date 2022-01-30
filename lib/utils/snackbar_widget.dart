import 'package:flutter/material.dart';

class SnackBarWidget {
  static ScaffoldMessengerState? loadingSnackBar(BuildContext context) =>
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: Duration(seconds: 60),
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            behavior: SnackBarBehavior.fixed,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            )),
            content: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "LOADING",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Please wait...",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                const Spacer(),
                const CircularProgressIndicator()
              ],
            ),
          ),
        );

  static ScaffoldMessengerState? errorSnackBar(
          BuildContext context, String message) =>
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            // duration: const Duration(seconds: 60),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.fixed,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            )),
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
                  message,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onError),
                )
              ],
            ),
          ),
        );

  static ScaffoldMessengerState? successSnackBar(
          BuildContext context, String message) =>
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            // duration: const Duration(seconds: 60),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.fixed,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            )),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                // SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        );
}
