import 'package:apps/utils/importer.dart';

class DashbordScreen extends StatelessWidget {
  DashbordScreen({Key? key}) : super(key: key);
  static const route = '/dashbord';
  final double width = getScreenWidth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: ListView(
            children: [
              verticalSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(ImagesUtils.logoImages),
                  Builder(builder: (context) {
                    return InkWell(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Icon(
                        Icons.menu,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }),
                ],
              ),
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
                                BlocProvider.of<ShopsBloc>(context).add(
                                  LoadShopsEvent(
                                    date: state.taskList[index] ?? '',
                                  ),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Shopsscreen(
                                      date: getDate(index),
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
    );
  }
}
