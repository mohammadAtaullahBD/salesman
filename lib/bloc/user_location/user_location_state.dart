// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_location_bloc.dart';

sealed class UserLocationState extends Equatable {
  const UserLocationState();

  @override
  List<Object> get props => [];
}

class UserLocationInitialState extends UserLocationState {}

class UserLocationErrorState extends UserLocationState {
  final String error;
  const UserLocationErrorState({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
