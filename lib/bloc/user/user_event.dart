part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class ResetUserEvent extends UserEvent {}

class FetchPreviousIfAvailableEvent extends UserEvent {}

class FetchUserEvent extends UserEvent {
  final String email;
  final String password;
  const FetchUserEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
