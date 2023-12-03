import 'package:apps/utils/importer.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final ShopsRepository _shopsRepository = ShopsRepository();
  Timer? _timer;

  TaskListBloc() : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is FeatchTaskList) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        int? userID = prefs.getInt('userID');
        try {
          if (userID != null) {
            List<String?> taskList = await _shopsRepository.getShopList(userID);
            emit(TaskListFeached(taskList: taskList));
            _timer ??= Timer.periodic(const Duration(seconds: 30), (timer) {
              debugPrint('periodic FeatchTaskList');
              add(FeatchTaskList());
            });
          }
        } catch (e) {
          emit(TaskListFeachedError(
            error: e.toString(),
          ));
        }
      }
    });
  }

  // @override
  // void close() {
  //   _timer?.cancel();
  //    super.close();
  // }
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
