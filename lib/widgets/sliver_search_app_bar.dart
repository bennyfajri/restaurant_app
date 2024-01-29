import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/widgets/search_bar.dart' as sc;

import '../util/background_wave.dart';

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  final sc.OnSearchTermChanged onSearchTermChanged;

  SliverSearchAppBar({required this.onSearchTermChanged});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final adjustedShrink = shrinkOffset * 2;
    final snap = adjustedShrink > 60;
    double searchExtraOffset = ((280 - adjustedShrink) * 0.36).abs().toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 280,
          child: ClipPath(
            clipper: BackgroundWaveClipper(),
            child: AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [startColor, endColor],
                stops: [0.0, 0.51],
                tileMode: TileMode.clamp,
              )),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: snap ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  "Restaurant App",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Recommendation restaurant for you",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 64 + searchExtraOffset,
          child: sc.SearchBar(onSearchTermChanged: onSearchTermChanged),
        )
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate != this;
}
