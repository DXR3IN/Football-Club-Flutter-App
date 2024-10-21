import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Shimmer appShimmer(Widget child) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.white,
    child: child,
  );
}

class HomeShimmerScreen extends StatefulWidget {
  const HomeShimmerScreen({super.key});

  @override
  State<HomeShimmerScreen> createState() => _HomeShimmerScreenState();
}

class _HomeShimmerScreenState extends State<HomeShimmerScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (width > 1200) {
      // Large screens (e.g., tablets or desktops)
      crossAxisCount = 8;
    } else if (width > 800) {
      // Medium screens (e.g., large phones)
      crossAxisCount = 5;
    } else if (width > 600) {
      crossAxisCount = 3;
    } else {
      // Small screens (e.g., regular phones)
      crossAxisCount = 2;
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return _itemCardShimmer();
      },
    );
  }

  Widget _itemCardShimmer() {
    return GridTile(
        child: appShimmer(
      Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(3, 3),
            ),
          ],
        ),
      ),
    ));
  }
}
