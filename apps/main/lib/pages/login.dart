import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap/data/repositories/auth.dart';
import 'package:injectable/injectable.dart';

import '../bloc/auth_bloc.dart';
import '../app_router.dart';

@Injectable()
class LoginPage extends StatefulWidget {
  final AuthBloc authBloc;
  final AuthRepository authRepository;

  const LoginPage(
      {Key? key, required this.authBloc, required this.authRepository})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

// login form in dart
class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // async function to login
  Future<void> login(BuildContext context, AuthState state) async {
    context.read<AuthBloc>().add(AuthEvent.signIn(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
            value: widget.authBloc..add(const AuthEvent.started()))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Form(
          key: _formKey,
          child: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              loaded: (state) => context.router.push(const HomeRoute()),
              error: (state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          }, child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    state.maybeMap(
                      orElse: () => ElevatedButton(
                        onPressed: () => login(context, state),
                        child: const Text('Submit'),
                      ),
                      loading: (_) => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ),
      ),
    );
  }
}
