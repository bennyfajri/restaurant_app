import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant_list.dart';
import 'package:restaurant_app/provider/database_provider.dart';

import '../provider/restaurant_provider.dart';
import '../ui/restaurant_detail_page.dart';
import '../util/constant.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({super.key, required this.restaurant});

  Widget _itemListRestaurants(IconData iconData, Color color, String? title) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 16,
        ),
        Text(title as String),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              child: SizedBox(
                height: 150,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Provider.of<RestaurantProvider>(
                        context,
                        listen: false,
                      ).fetchDetailRestaurant(restaurant.id);
                      Navigator.pushNamed(
                          context, RestaurantDetailPage.routeName,
                          arguments: restaurant.pictureId);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Hero(
                              tag: restaurant.pictureId,
                              child: Image.network(
                                "$baseUrlImg${restaurant.pictureId}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, exception, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.black26,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                _itemListRestaurants(
                                  Icons.place,
                                  Colors.redAccent,
                                  restaurant.city,
                                ),
                                _itemListRestaurants(
                                  Icons.star,
                                  Colors.orangeAccent,
                                  restaurant.rating.toString(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            isBookmarked
                                ? IconButton(
                                    icon: const Icon(Icons.favorite),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    onPressed: () =>
                                        provider.removeFavorited(restaurant.id),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    onPressed: () =>
                                        provider.addFavorite(restaurant),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}
