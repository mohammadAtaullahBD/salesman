import 'package:salesman/utils/importer.dart';

class DashbordScreen extends StatelessWidget {
  const DashbordScreen({super.key});
  // static const route = dashbordScreenRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc()..add(FetchTaskList()),
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(ImagesUtils.logoImages),
            ),
          ],
          title: Text(
            'Your task list',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: ListView(
              children: [
                verticalSpace(),
                BlocBuilder<TaskListBloc, TaskListState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    if (state is TaskListFetched) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                if (state.taskList[index] != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShopsScreen(
                                        date: state.taskList[index] ?? '',
                                      ),
                                    ),
                                  );
                                } else {
                                  showToastMessage(
                                    context,
                                    'There is no task assigned for Day ${index + 1}',
                                  );
                                }
                              },
                              leading: const Icon(
                                Icons.calendar_month,
                                color: primaryColor,
                              ),
                              title: Text('Day ${index + 1}'),
                              subtitle: Text(state.taskList[index] ?? ''),
                            ),
                          );
                        },
                      );
                    } else if (state is TaskListFetchedError) {
                      return Center(
                        child: Text('Error: ${state.error}'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
