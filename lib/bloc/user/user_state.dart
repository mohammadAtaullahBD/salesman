part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadedState extends UserState {
  final User user;
  const UserLoadedState({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class UserErrorState extends UserState {
  final String error;
  const UserErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
