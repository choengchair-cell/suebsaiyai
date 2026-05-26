import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/auth/auth_state.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/domain/repositories/auth_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthStateInitial()) {
    _init();
  }

  final AuthRepository _repo;
  StreamSubscription? _sub;

  void _init() {
    state = const AuthStateLoading();
    _sub = _repo.authStateChanges.listen(
      (user) => state = user != null ? AuthStateAuthenticated(user) : const AuthStateUnauthenticated(),
      onError: (_) => state = const AuthStateUnauthenticated(),
    );
  }

  Future<String?> signIn(String email, String password) async {
    state = const AuthStateLoading();
    final result = await _repo.signInWithEmailAndPassword(email, password);
    return result.fold((f) {
      state = AuthStateError(f.message);
      return f.message;
    }, (user) {
      state = AuthStateAuthenticated(user);
      return null;
    });
  }

  Future<String?> register(String email, String password, String displayName, String districtId) async {
    state = const AuthStateLoading();
    final result = await _repo.createUserWithEmailAndPassword(email, password, displayName, districtId);
    return result.fold((f) {
      state = AuthStateError(f.message);
      return f.message;
    }, (user) {
      state = AuthStateAuthenticated(user);
      return null;
    });
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthStateUnauthenticated();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);

final currentUserProvider = Provider((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthStateAuthenticated ? authState.user : null;
});

final isAuthenticatedProvider = Provider((ref) => ref.watch(authNotifierProvider) is AuthStateAuthenticated);
