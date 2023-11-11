import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(
      {super.key,
      this.heading,
      this.description,
      this.actionName,
      this.action});

  final String? heading;
  final String? description;
  final String? actionName;
  final Function()? action;

  _showActionButton() {
    if (action != null) {
      return FilledButton(
        onPressed: action,
        child: Text(
          actionName ?? 'Search',
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
            Image.asset('assets/images/common/empty.png',
                fit: BoxFit.cover, height: double.infinity),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    heading ?? 'No Results',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    description ??
                        'Sorry there are no results for this search, please try another phrase',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
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
