import 'package:example/home_page/home_page.dart';
import 'package:example/home_page/home_page_logic.dart';
import 'package:example/home_page/home_page_state.dart';
import 'package:example/login/login_logic.dart';
import 'package:example/login/login_state.dart';
import 'package:example/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repository instance
    final authRepository = AuthRepository();

    return MaterialApp(
      title: 'mu_state Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MuMultiProvider([
        (child) => MuProvider<LoginLogic, LoginState>(
              logic: LoginLogic(authRepository),
              child: child,
            ),
        (child) => MuProvider<HomePageLogic, HomePageState>(
              logic: HomePageLogic(authRepository),
              child: child,
            ),
      ], child: const ErrorListenerWrapper()),
    );
  }
}

class ErrorListenerWrapper extends StatelessWidget {
  const ErrorListenerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageLogic = context.logic<HomePageLogic, HomePageState>();

    return MuListener<HomePageState>(
      logic: homePageLogic,
      listener: (context, state) {
        if (state.status == HomePageStatus.error) {
          String message = switch (state.messageType) {
            HomePageMessage.networkError => '🌐 Network error occurred',
            HomePageMessage.incrementError => '🔢 Counter error occurred',
            _ => '⚠️ An unexpected error occurred',
          };

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      listenWhen: (previous, current) => current.status == HomePageStatus.error,
      child: const HomePage(),
    );
  }
}
