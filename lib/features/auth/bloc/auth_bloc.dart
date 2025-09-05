import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qchat_app/features/auth/bloc/auth_event.dart';
import 'package:qchat_app/features/auth/bloc/auth_state.dart';
import 'package:qchat_app/features/auth/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
        role: event.role,
      );
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
