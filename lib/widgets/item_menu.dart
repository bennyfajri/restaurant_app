import 'package:flutter/material.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class ItemMenu extends StatelessWidget {
  final Category menu;
  final IconData icon;

  const ItemMenu({super.key, required this.menu, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    menu.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
