import 'package:salesman/utils/importer.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final void Function() onPressed;

  const AlertDialogWidget({
    required this.title,
    required this.message,
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Text(title),
        content: Text(message),
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
