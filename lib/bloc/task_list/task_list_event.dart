part of 'task_list_bloc.dart';

sealed class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object> get props => [];
}

final class FeatchTaskList extends TaskListEvent {
  final int uID;
  const FeatchTaskList({required this.uID});

  @override
  List<Object> get props => [uID];
}
