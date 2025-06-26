import 'package:example/login/login_logic.dart';
import 'package:example/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to text changes to rebuild the widget
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginLogic = context.logic<LoginLogic, LoginState>();

    return MuBuilder<LoginState>(
      valueListenable: loginLogic,
      builder: (context, loginState, child) {
        if (loginState.isLoggedIn) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome, ${loginState.user}!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: loginState.isLoading ? null : loginLogic.logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !loginState.isLoading,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        loginState.isLoading || _controller.text.trim().isEmpty
                            ? null
                            : () {
                                loginLogic.login(_controller.text.trim());
                                _controller.text = '';
                              },
                    child: loginState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                ),
                if (loginState.error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    loginState.error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
