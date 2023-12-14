import 'package:flutter/material.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';

import 'generic_dialog.dart';

Future<void> showPasswordRestSentDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: context.loc.password_reset,
      content: context.loc.password_reset_dialog_prompt,
      optionBuilder: () => {
            context.loc.ok: null,
          });
}
