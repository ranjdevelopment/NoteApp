import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/firebase_options.dart';
import 'package:learning_flutter/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({super.key});

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  TextEditingController emailVerifyController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 17.0,
        title: Text(
          context.loc.verify_email,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.loc.verify_email_view_prompt,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventSendEmailVerification());
                      },
                      minWidth: 350,
                      height: 50,
                      color: Colors.green,
                      elevation: 17.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        context.loc.verify_email_send_email_verification,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      minWidth: 350,
                      height: 50,
                      color: Colors.green,
                      elevation: 17.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        context.loc.restart,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
