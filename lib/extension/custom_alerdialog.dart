import 'package:flutter/material.dart';

class SimpleConfirmDialog extends StatelessWidget {
  final String content;

  final VoidCallback onConfirmed;
  const SimpleConfirmDialog({
    Key? key,
    required this.content,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(""),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onConfirmed();
            // Navigator.of(context).pop(true);
          },
          child: const Text("Confirm"),
        ),
        // TextButton(
        //   // onPressed: () => Navigator.of(context).pop(false),
        //   child: const Text("CANCEL"),
        // ),
      ],
    );
  }
}
