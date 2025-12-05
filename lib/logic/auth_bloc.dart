import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- Events ---
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

// --- States ---
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
}

// --- BLoC ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>((event, emit) => emit(AuthInitial()));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation (accept any non-empty input for now)
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(AuthAuthenticated());
      } else {
        emit(const AuthFailure("Please fill in all fields"));
      }
    } catch (e) {
      emit(const AuthFailure("An unexpected error occurred"));
    }
  }
}