import 'package:flutter/material.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.generic_error_prompt,
    content: text,
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
