import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class ItemReview extends StatelessWidget {
  final CustomerReview customerReview;
  static Color avatarColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  const ItemReview({super.key, required this.customerReview});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    color: avatarColor,
                  ),
                  child: Center(
                    child: Text(
                      customerReview.name[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        customerReview.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        customerReview.date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(customerReview.review),
            const SizedBox(height: 16.0)
          ],
        ),
      ),
    );
  }
}
