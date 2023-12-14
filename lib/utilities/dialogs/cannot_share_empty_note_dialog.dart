import 'package:flutter/cupertino.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note!',
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
