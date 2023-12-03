import 'package:apps/utils/importer.dart';

class DashbordScreen extends StatelessWidget {
  const DashbordScreen({super.key});
  // static const route = dashbordScreenRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc()..add(FeatchTaskList()),
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          title: Text('Your Task List:',style: Theme.of(context).textTheme.titleMedium,),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: ListView(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Image.asset(ImagesUtils.logoImages),
                //     Builder(builder: (context) {
                //       return InkWell(
                //         onTap: () => Scaffold.of(context).openDrawer(),
                //         child: Icon(
                //           Icons.menu,
                //           color: Theme.of(context).colorScheme.primary,
                //         ),
                //       );
                //     }),
                //   ],
                // ),
                verticalSpace(),
                BlocBuilder<TaskListBloc, TaskListState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    if (state is TaskListFeached) {
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
                              leading: const Icon(Icons.calendar_month),
                              title: Text('Day ${index + 1}'),
                              subtitle: Text(state.taskList[index] ?? ''),
                            ),
                          );
                        },
                      );
                    } else if (state is TaskListFeachedError) {
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
