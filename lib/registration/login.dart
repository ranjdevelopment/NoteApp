import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener, ReadContext;
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/services/auth/auth_exceptions.dart';
import 'package:learning_flutter/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:learning_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_event.dart';
import 'package:learning_flutter/services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  bool pass = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, context.loc.login_error_cannot_find_user);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          elevation: 17.0,
          title: Text(
            context.loc.login,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
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
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: passController,
                    obscureText: pass,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            pass = !pass;
                          });
                        },
                        icon: pass
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              ),
                      ),
                      hintText: context.loc.password_text_field_placeholder,
                      label: const Text("Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    minWidth: 350,
                    height: 50,
                    onPressed: () async {
                      context.read<AuthBloc>().add(AuthEventLogIn(
                            emailController.text.trim(),
                            passController.text.trim(),
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.green,
                    elevation: 17.0,
                    child: Text(
                      context.loc.login,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 190.0),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventForgotPassword(),
                            );
                      },
                      child: Text(
                        context.loc.login_view_forgot_password,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            context.loc.login_view_not_registered_yet,
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
                              context.read<AuthBloc>().add(
                                    const AuthEventShouldRegister(),
                                  );
                            },
                            child: Text(
                              context.loc.register,
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
