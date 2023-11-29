part of 'shops_bloc.dart';

sealed class ShopsState extends Equatable {
  const ShopsState();

  @override
  List<Object> get props => [];
}

// lodding or initial
class ShopsInitialState extends ShopsState {}

// loaded state
class ShopsLoadedState extends ShopsState {
  final List<Shop> shops;
  const ShopsLoadedState(this.shops);

  @override
  List<Object> get props => [shops];
}

// error state
class ShopsErrorState extends ShopsState {
  final String error;
  const ShopsErrorState(this.error);

  @override
  List<Object> get props => [error];
}
