import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/widgets/restaurant_item.dart';

import '../provider/database_provider.dart';
import '../util/result_state.dart';
import '../widgets/platform_widget.dart';

class RestaurantFavoritePage extends StatelessWidget {
  static const String favoriteTitle = 'Favorit';
  const RestaurantFavoritePage({super.key});

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(favoriteTitle),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(favoriteTitle),
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return RestaurantItem(
                restaurant: provider.favorites[index],
              );
            },
          );
        } else {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Center(
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    children: [
                      Image.asset("assets/empty_data.png"),
                      Text(
                        "Oops!",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Text("Belum ada data"),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
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
