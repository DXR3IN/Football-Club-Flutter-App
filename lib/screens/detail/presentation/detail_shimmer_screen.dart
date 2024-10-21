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
            _buildInfo(),
            const SizedBox(height: 26),
            _buildMediaSocials(),
            const SizedBox(height: 30),
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

  Widget _buildInfo() {
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

  Widget _buildMediaSocials() {
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
