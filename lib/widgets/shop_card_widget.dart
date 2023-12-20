import 'package:apps/utils/importer.dart';

// user Card
class ShopCard extends StatelessWidget {
  final Shop shop;

  const ShopCard({
    super.key,
    required this.shop,
  });

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.5, // 50% of the screen height
          color: Colors.white,
          child: Column(
            children: [
              verticalSpace(height: 0.1),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Table(
                    border: TableBorder.all(
                      width: 1.0,
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    children: [
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Shop name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color.fromARGB(255, 13, 13, 14)),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '${shop.name}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Address',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color.fromARGB(255, 13, 13, 14)),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '${shop.address}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Phone',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color.fromARGB(255, 13, 13, 14)),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '${shop.number}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      launchWaze(shop.coordinate);
                    },
                    child: const Text(
                      'view map',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: whitePrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              height: 32.0 * 2,
              width: 32.0 * 2,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(7.5),
              ),
              // color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: Icon(
                  Icons.shop_2_rounded,
                  size: 28.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${shop.name}',
                      style: Theme.of(context).textTheme.bodyLarge),
                  verticalSpace(height: 0.01),
                  Text('${shop.address}'),
                  Text('Code: ${shop.id}'),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 75.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      _openModal(context);
                    },
                    child: Center(
                      child: Text(
                        'view info',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                // spaceV(10.0),
                verticalSpace(height: 0.012),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
