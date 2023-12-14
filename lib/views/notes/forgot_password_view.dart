import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_event.dart';
import 'package:learning_flutter/services/auth/bloc/auth_state.dart';
import 'package:learning_flutter/utilities/dialogs/error_dialog.dart';
import 'package:learning_flutter/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordRestSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              context.loc.forgot_password_view_generic_error,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            context.loc.forgot_password,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(children: [
              Text(
                context.loc.forgot_password_view_prompt,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: context.loc.email_text_field_placeholder,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: Text(
                  context.loc.forgot_password_view_send_me_link,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text(
                  context.loc.forgot_password_view_back_to_login,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
