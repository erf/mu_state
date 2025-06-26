import 'package:mu_state/mu_state.dart';

/// Login state
class LoginState with MuComparable {
  final String user;
  final bool signedIn;
  final bool isLoading;
  final String? error;

  const LoginState({
    this.user = '',
    this.signedIn = false,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => signedIn;

  LoginState copyWith({
    String? user,
    bool? signedIn,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      user: user ?? this.user,
      signedIn: signedIn ?? this.signedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [user, signedIn, isLoading, error];
}
