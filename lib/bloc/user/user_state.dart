part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadedState extends UserState {
  final int userID;
  const UserLoadedState({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}

class UserErrorState extends UserState {
  final String error;
  const UserErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
