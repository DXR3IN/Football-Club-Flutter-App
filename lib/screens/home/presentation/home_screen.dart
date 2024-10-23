import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/home/controller/home_controller.dart';
import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';
import 'package:premiere_league_v2/screens/home/presentation/home_shimmer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController(getIt.get());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.dummyTeamFCCommand.execute();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _favoriteCaller(
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.star_border,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // _sliverAppBar(),
            _navBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: AppObserverBuilder(
                commandQuery: _controller.dummyTeamFCCommand,
                onLoading: () => const HomeShimmerScreen(),
                child: (data) {
                  return _contentBody(data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _sliverAppBar() {
  //   return SliverAppBar(
  //     automaticallyImplyLeading: false,
  //     pinned: true,
  //     floating: true,
  //     expandedHeight: 200.0,
  //     flexibleSpace: FlexibleSpaceBar(
  //       background: Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(200),
  //                 bottomRight: Radius.circular(50)),
  //             child: Image.asset(
  //               "assets/banner/premiere-league-banner2.png",
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //         ],
  //       ),
  //       title: Text(AppConst.appName),
  //       centerTitle: true,
  //     ),
  //   );
  // }

  Widget _navBar() {
    return Stack(
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            child: Image.asset("assets/background.jpg")),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [_searchBar()],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20, left: 30, right: 30, top: 40),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2 - 22,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/banner/premiere-league-banner2.png"),
                      fit: BoxFit.cover,
                    ),
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
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 20,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Observer(
                              builder: (context) {
                                final isLoading = _controller.isLoading.value;
                                if (isLoading) {
                                  return const Text(
                                    "0 Premier Team",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  );
                                }

                                return Text(
                                  "${_controller.totalTeam.value} Premier Team",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contentBody(List<HomeClubModel> listTeam) {
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

    return Observer(builder: (_) {
      final displayList = _controller.searchQuery.value.isEmpty
          ? listTeam
          : _controller.filteredTeams;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayList.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemCardFC(displayList[index]);
        },
      );
    });
  }

  Widget _searchBar() {
    return Observer(
      builder: (_) => Expanded(
        child: TextField(
          onChanged: (value) {
            _controller.updateSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: 'Search teams...',
            hintStyle: const TextStyle(color: Colors.white),
            suffixIcon: _favoriteCaller(
              const Icon(
                Icons.star_border,
              ),
            ),
            suffixIconColor: Colors.white,
            fillColor: Colors.white,
            iconColor: Colors.white,
            focusColor: Colors.white,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
            ),
          ),
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _favoriteCaller(Widget icon) {
    return GestureDetector(
      child: icon,
      onTap: () {
        _controller.onTapFavScreen();
      },
    );
  }

  Widget _itemCardFC(HomeClubModel footballClub) {
    final imageUrl = footballClub.badge ?? '';

    return GestureDetector(
      onTap: () {
        logger.i("id team is : ${footballClub.idTeam}");
        _controller.onTapItemFootBall(footballClub.team!);
      },
      child: GridTile(
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Hero(
                    tag: footballClub.team!,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Image.asset(
                        "assets/placeholder/logoclub-placeholder.png",
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                footballClub.team!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
