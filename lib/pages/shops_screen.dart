import 'package:apps/utils/importer.dart';

class Shopsscreen extends StatelessWidget {
  final String date;

  const Shopsscreen({super.key, required this.date});
  static const route = '/shops';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
        drawer: const DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              verticalSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO: Set the logo
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
                          date,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(),
              BlocBuilder<ShopsBloc, ShopsState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is ShopsInitialState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ShopsLoadedState) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.shops.length,
                        itemBuilder: (context, index) =>
                            ShopCard(shop: state.shops[index]),
                      ),
                    );
                    // return Builder(builder: (context)=>Center());
                    // ;
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
            ],
          ),
        ),
      ),
    );
  }
}
