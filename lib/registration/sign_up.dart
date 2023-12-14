import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_event.dart';
import 'package:learning_flutter/services/auth/bloc/auth_state.dart';

import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  bool _pass = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.register_error_generic);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_invalid_email);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 20.0,
          centerTitle: true,
          title: Text(
            context.loc.register,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintText: context.loc.email_text_field_placeholder,
                      label: const Text("Email"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: passController,
                    obscureText: _pass,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _pass = !_pass;
                          });
                        },
                        icon: _pass
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        color: Colors.black,
                      ),
                      hintText: context.loc.password_text_field_placeholder,
                      label: const Text("Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(AuthEventRegister(
                            emailController.text.trim(),
                            passController.text.trim()));
                      },
                      minWidth: 350.0,
                      height: 50,
                      color: Colors.green,
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        context.loc.register,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 30),
                          child: Text(
                            context.loc.register_view_already_registered,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventLogOut());
                            },
                            child: Text(
                              context.loc.login,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
