import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant_list.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/util/constant.dart';
import 'package:restaurant_app/widgets/item_menu.dart';
import 'package:restaurant_app/widgets/item_review.dart';

import '../data/models/restaurant_detail.dart';
import '../util/result_state.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = "/restaurant_detail";
  final String pictureId;

  const RestaurantDetailPage({super.key, required this.pictureId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<RestaurantProvider, DatabaseProvider>(
        builder: (context, restaurantProvider, databaseProvider, _) {
          DetailRestaurant? restaurants =
              restaurantProvider.detailRestaurantResult?.restaurant;
          if (restaurantProvider.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
              ),
            );
          } else if (restaurantProvider.state == ResultState.hasData) {
            List<Category>? listFoods = restaurants?.menus.foods;
            List<Category>? listDrinks = restaurants?.menus.drinks;
            List<CustomerReview> listReview =
                restaurants?.customerReviews ?? [];
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              slivers: [
                //appbar
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: pictureId,
                      child: Image.network(
                        ("$baseUrlImg${restaurants?.pictureId}"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    title: Text(
                      restaurants?.name ?? "",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                  actions: [
                    FutureBuilder<bool>(
                        future: databaseProvider.isFavorited(restaurantProvider
                            .detailRestaurantResult!.restaurant.id),
                        builder: (context, snapshot) {
                          var isBookmarked = snapshot.data ?? false;
                          return isBookmarked
                              ? IconButton(
                                  icon: const Icon(Icons.favorite),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () => databaseProvider
                                      .removeFavorited(restaurantProvider
                                          .detailRestaurantResult!
                                          .restaurant
                                          .id),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () =>
                                      databaseProvider.addFavorite(Restaurant(
                                    id: restaurants?.id ?? "",
                                    name: restaurants?.name ?? "",
                                    description: restaurants?.description ?? "",
                                    pictureId: restaurants?.pictureId ?? "",
                                    city: restaurants?.city ?? "",
                                    rating: restaurants?.rating ?? 0.0,
                                  )),
                                );
                        })
                  ],
                ),
                // body/content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.place,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  restaurantProvider
                                      .detailRestaurantResult!.restaurant.city
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  restaurantProvider
                                      .detailRestaurantResult!.restaurant.rating
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Deskripsi",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(restaurantProvider
                            .detailRestaurantResult!.restaurant.description),
                        const SizedBox(height: 16),
                        Text(
                          "Daftar Menu",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Makanan",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listFoods?.length,
                            itemBuilder: (context, index) {
                              return listFoods!.isNotEmpty
                                  ? ItemMenu(
                                      menu: listFoods[index],
                                      icon: Icons.fastfood_rounded)
                                  : const Text(
                                      "Menu tidak tersedia",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Minuman",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listDrinks?.length,
                            itemBuilder: (context, index) {
                              return listDrinks!.isNotEmpty
                                  ? ItemMenu(
                                      menu: listDrinks[index],
                                      icon: Icons.emoji_food_beverage_rounded)
                                  : const Text(
                                      "Menu tidak tersedia",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    );
                            },
                          ),
                        ),
                        Text(
                          "Penilaian",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                listReview.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ItemReview(
                              customerReview: listReview[index],
                            );
                          },
                          childCount: listReview.length,
                        ),
                      )
                    : const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Belum ada review",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
              ],
            );
          } else {
            return Center(
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(restaurantProvider.message),
                    ElevatedButton(
                      onPressed: () {
                        restaurantProvider.fetchRestaurants();
                      },
                      child: const Text("Ulangi kembali"),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
