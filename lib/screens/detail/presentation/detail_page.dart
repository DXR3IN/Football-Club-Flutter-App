import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/components/util/hex_to_color.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/button/like_equipment_button.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';
import 'package:premiere_league_v2/screens/detail/presentation/google_maps_popup.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailPage extends StatefulWidget {
  final ClubModel team;
  final DetailController controller;
  const DetailPage({super.key, required this.team, required this.controller});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      const SizedBox(height: 20),
      _buildInfo(widget.team),
      const SizedBox(height: 30),
      _buildEquipmentObserver(),
      const SizedBox(height: 30),
      _buildMediaSocials(widget.team),
      const SizedBox(height: 30),
      _buildDescription(widget.team),
      const SizedBox(height: 5),
      _bottomDesign(widget.team)
    ]);
  }

  Widget _buildInfo(ClubModel team) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 1.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.formedYear(team.formedYear!),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.stadium(team.stadium!),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: "${AppLocalizations.of(context)!.location}: ",
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                children: [
                  TextSpan(
                    text: team.location,
                    style: const TextStyle(
                        overflow: TextOverflow.fade,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => GoogleMapsPopup(
                              location: team.location ?? team.stadium),
                        );
                      },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSocials(ClubModel team) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.socialMedia,
              style: const TextStyle(fontSize: 18)),
          _buildMediaItem(
              team.instagram!, Colors.pink, Ionicons.logo_instagram),
          _buildMediaItem(team.youtube!, Colors.red, Ionicons.logo_youtube),
          _buildMediaItem(team.facebook!, Colors.blue, Ionicons.logo_facebook),
        ],
      ),
    );
  }

  Widget _buildMediaItem(String url, Color color, IconData icon) {
    if (url.isEmpty) return const SizedBox();

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(url),
      onTap: () {
        widget.controller.launchUrl(url);
      },
    );
  }

  Widget _buildDescription(ClubModel team) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: team.banner!,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      widget.controller.descIsLong.value =
                          !(widget.controller.descIsLong.value);
                    },
                    child: Column(
                      children: [
                        Text(
                          team.desc!,
                          maxLines:
                              widget.controller.descIsLong.value ? 7 : null,
                          overflow: widget.controller.descIsLong.value
                              ? TextOverflow.ellipsis
                              : null,
                        ),
                        Text(
                          widget.controller.descIsLong.value
                              ? AppLocalizations.of(context)!.showMoreHint
                              : AppLocalizations.of(context)!.showLessHint,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentObserver() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.jersey,
              style: const TextStyle(fontSize: 18)),
          const SizedBox(
            height: 10,
          ),
          AppObserverBuilder(
            commandQuery: widget.controller.dummyEquipmentCommand,
            onLoading: () {
              return CarouselSlider.builder(
                itemCount: 3,
                options: CarouselOptions(
                  viewportFraction: 0.5,
                  // aspectRatio: 1 / 1,
                  pageSnapping: false,
                  initialPage: 2,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  scrollDirection: Axis.horizontal,
                ),
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
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
            },
            onError: (message) => Container(
              color: Colors.red,
              child: Center(
                child: Text(message),
              ),
            ),
            child: (equipmentData) {
              // Check if the data is null or empty
              if (equipmentData == null || equipmentData.isEmpty) {
                logger.i(
                    "Equipment is $equipmentData and runtimeType ${equipmentData.runtimeType}");
                return Center(
                    child: Text(AppLocalizations.of(context)!.equipmentError));
              }

              // Cast to the expected type (e.g., List<EquipmentModel>)
              var equipmentList = equipmentData as List<EquipmentModel>;

              return CarouselSlider.builder(
                itemCount: equipmentList.length,
                options: CarouselOptions(
                  viewportFraction: 0.5,
                  height: 200,
                  aspectRatio: 1 / 1,
                  pageSnapping: true,
                  initialPage: (equipmentList.length / 2).round(),
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  scrollDirection: Axis.horizontal,
                ),
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  var equipment = equipmentList[itemIndex];

                  return Container(
                    // padding: const EdgeInsets.all(5),
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
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: CachedNetworkImage(
                            imageUrl: equipment.strEquipment!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.white,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            equipment.strSeason!,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 32, 0, 83),
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  color: Colors.white,
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: LikeEquipmentButton(equipment: equipment),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: AppStyle.primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10))),
                            child: Text(
                              equipment.type!,
                              style:
                                  const TextStyle(color: AppStyle.thirdColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomDesign(ClubModel team) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SizedBox(
          height: width / 5,
          width: width,
          child: CustomPaint(
            painter: WavePainter(
              color1: hexToColor(team.colour1!),
              color2: hexToColor(team.colour2!),
              offset: 10,
            ),
          ),
        ),
        Positioned(
          top: 20,
          child: SizedBox(
            height: width / 5,
            width: width,
            child: CustomPaint(
              painter: WavePainter(
                color1: hexToColor(team.colour2!),
                color2: hexToColor(team.colour1!),
                offset: 30,
              ),
            ),
          ),
        ),
      ],
    );
    // Container(
    //   height: 80,
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       colors: [
    //         hexToColor(team.colour1!),
    //         hexToColor(team.colour2!),
    //       ],
    //     ),
    //   ),
    // ),
  }
}

class WavePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double offset;

  WavePainter({
    required this.color1,
    required this.color2,
    this.offset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color1, color2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.6 + offset);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8 + offset,
      size.width * 0.5,
      size.height * 0.6 + offset,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4 + offset,
      size.width,
      size.height * 0.6 + offset,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
