import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/home_restaurants_list.dart';
import 'package:restaurant_app/widgets/sliver_search_app_bar.dart';
import '../widgets/platform_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
              ),
            ),
          );
        } else if (state.state == ResultState.hasData) {
          return HomeRestaurantList(
              restaurants: state.restaurantsResults.restaurants);
        } else {
          return SliverToBoxAdapter(
            child: Center(
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
            ),
          );
        }
      },
    );
  }

  Widget _buildNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              delegate: SliverSearchAppBar(
                onSearchTermChanged: (searchTerm) {
                  Provider.of<RestaurantProvider>(
                    context,
                    listen: false,
                  ).fetchRestaurants(query: searchTerm);
                },
              ),
              pinned: true,
            ),
          ),
        ];
      },
      body: Builder(
        builder: (context) => CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle:
              NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            _buildList(context)
          ],
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildNestedScrollView(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: _buildNestedScrollView(),
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
