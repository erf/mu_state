import 'package:example/auth_repository.dart';
import 'package:example/login/login_state.dart';
import 'package:mu_state/mu_state.dart';

/// Login logic that uses the repository
class LoginLogic extends MuLogic<LoginState> {
  final AuthRepository _repository;

  LoginLogic(this._repository) : super(const LoginState()) {
    // Listen to repository changes
    _repository.currentUser.addListener(_onUserChanged);
  }

  void _onUserChanged() {
    final user = _repository.currentUser.value;
    value = value.copyWith(
      user: user,
      isLoading: false,
    );
  }

  Future<void> login(String username) async {
    value = value.copyWith(isLoading: true, error: null);
    try {
      await _repository.login(username);
      // Explicitly set signedIn to true on successful login
      value = value.copyWith(
        signedIn: true,
        user: username,
        isLoading: false,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void logout() {
    _repository.logout();

    value = value.copyWith(
      signedIn: false,
    );
  }

  @override
  void dispose() {
    _repository.currentUser.removeListener(_onUserChanged);
    super.dispose();
  }
}
