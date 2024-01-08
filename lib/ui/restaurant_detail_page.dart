import 'package:flutter/material.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = "/restaurant_detail";
  final Restaurants restaurants;

  const RestaurantDetailPage({
    super.key,
    required this.restaurants,
  });

  Widget _buildItemMenu(BuildContext context, Menu menu) {
    return Material(
      child: Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.fastfood_outlined, size: 80,),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  menu.name as String,
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Menu> listMenus = [
      ...restaurants.menus?.foods as List<Menu>,
      ...restaurants.menus?.foods as List<Menu>
    ];
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  restaurants.pictureId != null
                      ? restaurants.pictureId as String
                      : "",
                  fit: BoxFit.fitWidth,
                ),
                title: Text(
                  restaurants.name as String,
                  style: TextStyle(
                    color: isScrolled ? Colors.black : Colors.white,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
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
                        ),
                        const SizedBox(width: 8),
                        Text(
                          restaurants.city as String,
                          style: Theme.of(context).textTheme.titleMedium,
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
                Text(restaurants.description as String),
                const SizedBox(height: 8),
                Text(
                  "Daftar Menu",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height/1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: listMenus.map(
                          (menus) {
                        return _buildItemMenu(context, menus);
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
