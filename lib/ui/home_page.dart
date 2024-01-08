import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

import '../widgets/platform_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  FutureBuilder<String> _buildList(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/local_restaurant.json'),
      builder: (context, snapshot) {
        final List<Restaurants> restaurants =
            parseListRestaurant(snapshot.data).restaurants as List<Restaurants>;
        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return _buildRestaurantItem(context, restaurants[index]);
          },
        );
      },
    );
  }

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

  Widget _buildRestaurantItem(BuildContext context, Restaurants restaurants) {
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
                arguments: restaurants,
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
                      restaurants.pictureId as String,
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
                          restaurants.name as String,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _itemListRestaurants(
                          Icons.place,
                          restaurants.city,
                        ),
                        _itemListRestaurants(
                          Icons.star,
                          restaurants.rating.toString(),
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

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Restaurant",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                titlePadding:
                    const EdgeInsets.only(left: 16, bottom: 16, top: 32),
              ),
            )
          ];
        },
        body: _buildList(context),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(slivers: [
        const CupertinoSliverNavigationBar(
          largeTitle: Text("Restaurant"),
        ),
        SliverFillRemaining(
          child: _buildList(context),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
