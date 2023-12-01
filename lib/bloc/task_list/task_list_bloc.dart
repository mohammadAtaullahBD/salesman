import 'package:apps/utils/importer.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final ShopsRepository _shopsRepository = ShopsRepository();
  TaskListBloc() : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is FeatchTaskList) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        int userID = prefs.getInt('userID')!;
        try {
          List<String?> taskList = await _shopsRepository.getShopList(userID);
          emit(TaskListFeached(taskList: taskList));
        } catch (e) {
          emit(TaskListFeachedError(
            error: e.toString(),
          ));
        }
      }
    });
  }
}
