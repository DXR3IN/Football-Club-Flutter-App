import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Shimmer appShimmer(Widget child) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.white,
    child: child,
  );
}

class DetailShimmerScreen extends StatefulWidget {
  const DetailShimmerScreen({super.key});

  @override
  State<DetailShimmerScreen> createState() => _DetailShimmerScreenState();
}

class _DetailShimmerScreenState extends State<DetailShimmerScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeaderShimmer(),
            _buildInfoShimmer(),
            const SizedBox(height: 30),
            _buildEquipmentShimmer(),
            const SizedBox(height: 26),
            _buildMediaSocialsShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        appShimmer(Container(
          width: width,
          height: width / 2,
          color: Colors.grey[300],
        )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: width,
                height: width / 15,
              ),
              Center(
                child: appShimmer(
                  Container(
                    width: width / 1.5,
                    height: height / 2.5,
                    decoration: ShapeDecoration(
                        shape: const CircleBorder(), color: Colors.grey[300]),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              appShimmer(
                Container(
                  width: width / 2,
                  height: width / 5,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoShimmer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          appShimmer(
            Container(
              width: 50,
              height: 18,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          appShimmer(
            Container(
              width: 50,
              height: 18,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentShimmer() {
    return CarouselSlider.builder(
      itemCount: 3,
      options: CarouselOptions(
        viewportFraction: 0.5,
        // aspectRatio: 1 / 1,
        pageSnapping: false,
        initialPage: 2,
        enableInfiniteScroll: true,
        autoPlay: false,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        // autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
      ),
    );
  }

  Widget _buildMediaSocialsShimmer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          appShimmer(
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          appShimmer(
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          appShimmer(
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
