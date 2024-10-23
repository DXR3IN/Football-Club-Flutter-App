import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/components/widget/hex_to_color.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';
import 'package:premiere_league_v2/screens/detail/favorite_button/favorite_button.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';
import 'package:premiere_league_v2/screens/detail/presentation/detail_shimmer_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.team});
  final String team;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DetailController(getIt.get());

    // Fetch team and equipment details
    _controller.fetchTeamAndEquipment(widget.team);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // appBar: _buildAppBar(),
      body: AppObserverBuilder(
        commandQuery: _controller.dummyDetailClubModel,
        onLoading: () => const DetailShimmerScreen(),
        onError: (error) => Center(child: Text('Error: $error')),
        child: (team) {
          _controller.teamFc.value = team;
          return _buildContent(team);
        },
      ),
      floatingActionButton: Observer(
        builder: (context) {
          // Check the loading state from the controller
          final loading = _controller.isLoading.value;

          if (loading) {
            return FloatingActionButton(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.white,
                child: Icon(
                  Icons.star,
                  color: Colors.grey[200],
                  size: 40,
                ),
              ),
              onPressed: () {},
            );
          }

          final team = _controller.teamFc.value;

          // Check if the team is loaded
          if (team == ClubModel()) {
            return const SizedBox();
          }

          // Build the favorite button when the team is available
          return FavoriteButton(team);
        },
      ),
    );
  }

  // PreferredSizeWidget _buildAppBar() {
  //   return AppBar(
  //     title: const Text("Detail Club"),
  //     centerTitle: true,
  //   );
  // }

  Widget _buildContent(ClubModel team) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(team),
            _buildInfo(team),
            const SizedBox(height: 30),
            _buildEquipmentObserver(),
            const SizedBox(height: 26),
            _buildMediaSocials(team),
            const SizedBox(height: 30),
            _buildDescription(team),
            const SizedBox(height: 20),
            _bottomDesign(team)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ClubModel team) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // CachedNetworkImage(
        //   imageUrl: team.banner!,
        //   placeholder: (context, url) => Shimmer.fromColors(
        //     child: Container(
        //       width: width,
        //       height: 75,
        //       color: Colors.grey[300],
        //     ),
        //     baseColor: Colors.grey[300]!,
        //     highlightColor: Colors.white,
        //   ),
        // ),

        Container(
          width: width,
          height: width / 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                hexToColor(team.colour1!),
                hexToColor(team.colour2!),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: width,
                height: width / 15,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      AppNav.navigator.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  child: Hero(
                    tag: team.team!,
                    child: CachedNetworkImage(
                      width: width / 1.5,
                      // height: height / 2.5,
                      imageUrl: team.badge!,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Image.asset(
                        "assets/placeholder/logoclub-placeholder.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                team.team!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width / 10,
                  color: hexToColor(team.colour1!),
                  shadows: [
                    Shadow(
                      offset: const Offset(1.0, 1.0),
                      color: hexToColor(team.colour2!),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(ClubModel team) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Formed Year: ${team.formedYear}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            "Stadium: ${team.stadium}",
            style: const TextStyle(fontSize: 18),
          ),
        ],
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
          const Text("Social Media", style: const TextStyle(fontSize: 18)),
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
      onTap: () async {
        try {
          await _launchUrl("https://$url");
        } catch (e) {
          Logger().i("Failed to launch URL: $e");
        }
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
                      _controller.descIsLong.value =
                          !(_controller.descIsLong.value);
                    },
                    child: Column(
                      children: [
                        Text(
                          team.desc!,
                          maxLines: _controller.descIsLong.value ? 7 : null,
                          overflow: _controller.descIsLong.value
                              ? TextOverflow.ellipsis
                              : null,
                        ),
                        Text(
                          _controller.descIsLong.value
                              ? "Show More"
                              : "Show Less",
                          style: TextStyle(color: Colors.blueAccent),
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
          const Text("Equipment", style: const TextStyle(fontSize: 18)),
          const SizedBox(
            height: 10,
          ),
          AppObserverBuilder(
            commandQuery: _controller.dummyEquipmentCommand,
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
                return const Center(child: Text("No equipment available"));
              }

              // Cast to the expected type (e.g., List<EquipmentModel>)
              var equipmentList = equipmentData as List<EquipmentModel>;

              return CarouselSlider.builder(
                itemCount: equipmentList.length,
                options: CarouselOptions(
                  viewportFraction: 0.5,
                  height: 200,
                  aspectRatio: 1 / 1,
                  pageSnapping: false,
                  initialPage: (equipmentList.length / 2).round(),
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
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  var equipment = equipmentList[itemIndex];

                  return Container(
                    padding: const EdgeInsets.all(5),
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
                        CachedNetworkImage(
                          imageUrl: equipment.strEquipment!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            "assets/placeholder/equipment-placeholder.png",
                            // fit: BoxFit.fill,
                          ),
                        ),
                        Center(
                          child: Text(
                            equipment.strSeason!,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 32, 0, 83),
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  color: Colors.white,
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                          ),
                        )
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
    return Container(
      height: width / 5,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.elliptical(500, 200)),
        gradient: LinearGradient(
          colors: [
            hexToColor(team.colour1!),
            hexToColor(team.colour2!),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  await launchUrl(uri);
}
