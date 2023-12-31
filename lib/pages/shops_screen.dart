import 'package:salesman/utils/importer.dart';

class ShopsScreen extends StatelessWidget {
  final String date;
  const ShopsScreen({
    super.key,
    required this.date,
  });
  // static const route = shopsScreenRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopsBloc()
        ..add(
          LoadShopsEvent(
            date: date,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(ImagesUtils.logoImages),
            ),
          ],
          title: Text(
            'Your Shop List:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0),
            child: BlocBuilder<ShopsBloc, ShopsState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                if (state is ShopsInitialState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ShopsLoadedState) {
                  if (state.shops == []) {
                    return const Center(
                      child: Text('There is no shop available.'),
                    );
                  }
                  return Column(
                    children: [
                      verticalSpace(),
                      verticalSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shop list',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Container(
                            width: 100.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  state.date,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.shops.length,
                          itemBuilder: (context, index) =>
                              ShopCard(shop: state.shops[index]),
                        ),
                      ),
                    ],
                  );
                } else if (state is ShopsErrorState) {
                  return Center(
                    child: Text('Error: ${state.error}'),
                  );
                }
                return const Center(
                  child: Text('There is no shop available.'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
