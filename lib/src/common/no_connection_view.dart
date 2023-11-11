import 'package:flutter/material.dart';

class NoConnectionView extends StatelessWidget {
  const NoConnectionView({super.key, this.actionName, this.action});

  final String? actionName;
  final Function()? action;

  _showActionButton() {
    if (action != null) {
      return FilledButton(
        onPressed: action,
        child: Text(
          actionName ?? 'RETRY',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/images/common/no_connection.png',
                fit: BoxFit.cover, height: double.infinity),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'No Connection..',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Your internet connection was interrupted. Please retry',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _showActionButton(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
