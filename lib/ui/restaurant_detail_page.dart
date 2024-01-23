import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/debouncer.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/util/constant.dart';
import 'package:restaurant_app/widgets/item_menu.dart';
import 'package:restaurant_app/widgets/item_review.dart';

import '../data/models/restaurant_detail.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = "/restaurant_detail";
  final String pictureId;

  const RestaurantDetailPage({super.key, required this.pictureId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final _scrollListener = Debouncer(const Duration(milliseconds: 50));
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollListener.run(() {
        setState(() {
          isScrolled = _scrollController.hasClients &&
              _scrollController.offset > (kToolbarHeight / 2);
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollListener.dispose();
    super.dispose();
  }

  bool isScrolledView(ScrollController controller) {
    return controller.hasClients && controller.offset > (kToolbarHeight / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
              ),
            );
          } else if (state.state == ResultState.hasData) {
            List<Category> listFoods =
                state.detailRestaurantResult!.restaurant.menus.foods;
            List<Category> listDrinks =
                state.detailRestaurantResult!.restaurant.menus.drinks;
            List<CustomerReview> listReview =
                state.detailRestaurantResult?.restaurant.customerReviews ?? [];
            return CustomScrollView(
              controller: _scrollController,
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
                      tag: widget.pictureId,
                      child: Image.network(
                        ("$baseUrlImg${state.detailRestaurantResult!.restaurant.pictureId}"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    title: Text(
                      state.detailRestaurantResult!.restaurant.name,
                      style: TextStyle(
                        color: isScrolled ? Colors.black : Colors.white,
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
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
                                  state.detailRestaurantResult!.restaurant.city
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
                                  state
                                      .detailRestaurantResult!.restaurant.rating
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                            // const Divider(color: Colors.black12,)
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Deskripsi",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(state
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
                            itemCount: listFoods.length,
                            itemBuilder: (context, index) {
                              return ItemMenu(
                                  menu: listFoods[index],
                                  icon: Icons.fastfood_rounded);
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
                            itemCount: listDrinks.length,
                            itemBuilder: (context, index) {
                              return ItemMenu(
                                  menu: listDrinks[index],
                                  icon: Icons.emoji_food_beverage_rounded);
                            },
                          ),
                        ),
                        Text(
                          "Penilaian",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        listReview.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: listReview.length,
                                itemBuilder: (context, index) {
                                  return ItemReview(
                                    customerReview: listReview[index],
                                  );
                                },
                              )
                            : const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                  "Belum ada review",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                            ),
                      ],
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
      ),
    );
  }
}
