import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flutter/constants/routes.dart';
import 'package:learning_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:learning_flutter/services/auth/firebase_auth_provider.dart';
import 'package:learning_flutter/views/notes/cretae_update_note_view.dart';
import 'package:learning_flutter/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
