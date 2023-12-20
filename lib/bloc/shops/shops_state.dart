part of 'shops_bloc.dart';

sealed class ShopsState extends Equatable {
  const ShopsState();

  @override
  List<Object> get props => [];
}

// loading or initial
class ShopsInitialState extends ShopsState {}

// loaded state
class ShopsLoadedState extends ShopsState {
  final String date;
  final List<Shop> shops;
  const ShopsLoadedState({required this.shops, required this.date});

  @override
  List<Object> get props => [shops];
}

// error state
class ShopsErrorState extends ShopsState {
  final String error;
  const ShopsErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
