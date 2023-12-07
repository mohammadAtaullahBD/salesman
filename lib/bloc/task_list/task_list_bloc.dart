import 'package:apps/utils/importer.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final ShopsRepository _shopsRepository = ShopsRepository();
  Timer? _timer;

  TaskListBloc() : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is FetchTaskList) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        int? userID = prefs.getInt('userID');
        try {
          if (userID != null) {
            List<String?> taskList = await _shopsRepository.getShopList(userID);
            if (taskList.length == 9) {
              emit(TaskListFetched(taskList: taskList));
            }else{
              debugPrint('Data Fetch error');
              throw Exception();
            }
            _timer ??= Timer.periodic(const Duration(minutes: 5), (timer) {
              debugPrint('periodic FetchTaskList');
              add(FetchTaskList());
            });
          }
        } catch (e) {
          emit(const TaskListFetchedError(
            error: 'Connection lost!',
          ));
          await Future.delayed(const Duration(seconds: 20));
          add(FetchTaskList());
        }
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
