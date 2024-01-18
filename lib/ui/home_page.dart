import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/util/constant.dart';

import '../data/models/restaurant_list.dart';
import '../widgets/platform_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.restaurantsResults.restaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantItem(
                  context, state.restaurantsResults.restaurants[index], state);
            },
          );
        } else {
          return Center(
            child: Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      state.fetchRestaurants();
                    },
                    child: const Text("Ulangi kembali"),
                  )
                ],
              ),
            ),
          );
        }
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

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant,
      [RestaurantProvider? state]) {
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
              state?.fetchDetailRestaurant(restaurant.id);
              if (state?.state == ResultState.loading) {

              } else if (state?.state == ResultState.hasData) {
                Navigator.pushNamed(
                  context,
                  RestaurantDetailPage.routeName,
                  arguments: state?.detailRestaurantResult,
                );
              } else {

              }

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
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge,
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall,
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
