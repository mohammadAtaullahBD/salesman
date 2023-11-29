part of 'task_list_bloc.dart';

sealed class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object> get props => [];
}

final class TaskListInitial extends TaskListState {}

class TaskListFeached extends TaskListState {
  final List<String?> taskList;
  const TaskListFeached({required this.taskList});
}

final class TaskListFeachedError extends TaskListState {
  final String error;
  const TaskListFeachedError({required this.error});
}
