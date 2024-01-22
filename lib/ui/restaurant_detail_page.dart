import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/debouncer.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/util/constant.dart';
import '../data/models/restaurant_detail.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = "/restaurant_detail";
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

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
    Provider.of<RestaurantProvider>(
      context,
      listen: false,
    ).fetchDetailRestaurant(widget.restaurantId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollListener.dispose();
    super.dispose();
  }

  Widget _buildItemMenu(BuildContext context, Category menu) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.fastfood_outlined,
            size: 60,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                menu.name,
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          )
        ],
      ),
    );
  }

  bool isScrolledView(ScrollController controller) {
    return controller.hasClients && controller.offset > (kToolbarHeight / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.state == ResultState.hasData) {
          List<Category> listMenus = [
            ...state.detailRestaurantResult!.restaurant.menus.foods,
            ...state.detailRestaurantResult!.restaurant.menus.drinks
          ];
          return Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      ("$baseUrlImg${state.detailRestaurantResult!.restaurant.pictureId}"),
                      fit: BoxFit.fitWidth,
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
                                  Icons.place_outlined,
                                  color: Colors.black26,
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.black26,
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
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Deskripsi",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(state.detailRestaurantResult!.restaurant.description),
                        const SizedBox(height: 8),
                        Text(
                          "Daftar Menu",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildItemMenu(context, listMenus[index]);
                    },
                    childCount: listMenus.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                )
              ],
            ),
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
}
