import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';

class CustomToast {
  static errorToast(BuildContext context, String content) {
    return CherryToast.error(
            title: const Text(""),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            description: Text(
              content,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            animationType: AnimationType.fromTop,
            toastDuration: const Duration(milliseconds: 1300),
            animationDuration: const Duration(milliseconds: 300),
            autoDismiss: true)
        .show(context);
  }

  static successToast(BuildContext context, String content) {
    return CherryToast.success(
            title: const Text(""),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            description: Text(
              content,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            animationType: AnimationType.fromTop,
            toastDuration: const Duration(milliseconds: 1300),
            animationDuration: const Duration(milliseconds: 300),
            autoDismiss: true)
        .show(context);
  }
}
