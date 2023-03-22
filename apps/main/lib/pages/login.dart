import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/login/login_bloc.dart';
import '../app_router.dart';

@Injectable()
class LoginPage extends StatefulWidget {
  final LoginBloc loginBloc;
  final Authentication authentication;

  const LoginPage(
      {Key? key, required this.loginBloc, required this.authentication})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login(BuildContext context, LoginState state) async {
    context.read<LoginBloc>().add(LoginEvent.signIn(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>.value(
            value: widget.loginBloc..add(const LoginEvent.start())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.login),
        ),
        body: Form(
          key: _formKey,
          child:
              BlocListener<LoginBloc, LoginState>(listener: (context, state) {
            state.maybeMap(
                orElse: () {},
                succeeded: (_) => context.router.replace(const HomeRoute()),
                errored: (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.loginFailed),
                        backgroundColor: Colors.red,
                      ),
                    ));
          }, child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.emailLabel,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterSomeText;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.passwordLabel,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterSomeText;
                        }
                        return null;
                      },
                    ),
                    state.maybeMap(
                      orElse: () => ElevatedButton(
                        onPressed: () => login(context, state),
                        child: Text(AppLocalizations.of(context)!.submit),
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
