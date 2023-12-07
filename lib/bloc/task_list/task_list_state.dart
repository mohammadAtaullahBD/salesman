part of 'task_list_bloc.dart';

sealed class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object> get props => [];
}

final class TaskListInitial extends TaskListState {}

class TaskListFetched extends TaskListState {
  final List<String?> taskList;
  const TaskListFetched({required this.taskList});

  @override
  List<Object> get props => [taskList];
}

final class TaskListFetchedError extends TaskListState {
  final String error;
  const TaskListFetchedError({required this.error});
}
