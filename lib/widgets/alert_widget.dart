import 'package:apps/utils/importer.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String massege;
  final void Function() onPressed;

  const AlertDialogWidget({
    required this.title,
    required this.massege,
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Text(title),
        content: Text(massege),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
