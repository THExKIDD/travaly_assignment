import 'package:equatable/equatable.dart';

enum LoginStatus {
  initial,
  loading,
  deviceRegistering,
  deviceRegistered,
  success,
  failure,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final String? visitorToken;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.visitorToken,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? visitorToken,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      visitorToken: visitorToken ?? this.visitorToken,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, visitorToken];
}
