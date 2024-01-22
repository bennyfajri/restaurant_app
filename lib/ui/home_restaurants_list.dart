import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/util/constant.dart';

import '../data/models/restaurant_list.dart';

class HomeRestaurantList extends StatelessWidget {
  final List<Restaurant> restaurants;

  const HomeRestaurantList({super.key, required this.restaurants});

  Widget _itemListRestaurants(IconData iconData, String? title) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.grey.withOpacity(0.5),
          size: 16,
        ),
        Text(title as String),
      ],
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context,
      Restaurant restaurant,
      ) {
    return Material(
      child: SizedBox(
        height: 150,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                RestaurantDetailPage.routeName,
                arguments: restaurant.id,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "$baseUrlImg${restaurant.pictureId}",
                      fit: BoxFit.cover,
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
                          restaurant.city,
                        ),
                        _itemListRestaurants(
                          Icons.star,
                          restaurant.rating.toString(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          final restaurant = restaurants[index];
          return TextButton(
            style: ButtonStyle(
              overlayColor:
              MaterialStateProperty.all(startColor.withOpacity(0.05)),
            ),
            onPressed: () {

            },
            child: _buildRestaurantItem(context, restaurant),
          );
        },
        childCount: restaurants.length,
      ),
    );
  }
}
