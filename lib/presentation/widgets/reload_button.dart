import 'package:flutter/material.dart';

import '../../utilities/extensions.dart';

/// This widget is made specifically when error occures as it can be displayed
/// as an error message and display a reload button to re-request on the fly
///
/// I can also make it receive a text to diplay custom text like (Refetch user data)
/// in the button depending on the screen it is rendered in
class ReloadButton extends StatelessWidget {
  const ReloadButton({
    super.key,
    required this.message,
    required this.onTap,
  });

  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message),
        8.emptyHeight,
        ElevatedButton(
          onPressed: onTap,
          child: const Text('Reload'),
        ),
      ],
    );
  }
}
