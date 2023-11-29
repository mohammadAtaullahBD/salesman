part of 'shops_bloc.dart';

sealed class ShopsEvent extends Equatable {
  const ShopsEvent();

  @override
  List<Object> get props => [];
}

class LoadShopsEvent extends ShopsEvent {
  final String date;

  const LoadShopsEvent({required this.date});

  @override
  List<Object> get props => [date];
}
