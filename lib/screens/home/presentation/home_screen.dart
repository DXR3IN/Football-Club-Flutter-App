import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/home/controller/home_controller.dart';
import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';
import 'package:premiere_league_v2/screens/home/presentation/home_shimmer_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final _controller = HomeController(getIt.get());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.listFootballClubCommand.execute();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _safeAreaWidget(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;

    final screenHeight = MediaQuery.of(context).size.height;

    double height;
    if (topPadding < 10.0) {
      height = screenHeight * 0.015;
    } else {
      height = screenHeight * 0.035;
    }

    return Container(
      height: height,
      color: AppStyle.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _favoriteCaller(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          _safeAreaWidget(context),
          _navBar(),
          Padding(
            padding: AppStyle.mainPadding,
            child: AppObserverBuilder(
              commandQuery: _controller.listFootballClubCommand,
              onLoading: () => const HomeShimmerScreen(),
              child: (data) {
                return _contentBody(data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBar() {
    return Stack(
      children: [
        _controller.isSearchBarFocused.value
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppConst.imageBackground),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
              )
            : ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Image.asset(AppConst.imageBackground)),
        Padding(
          padding:
              const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 5),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [_searchBar(), _settingsButton()],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
                child: _controller.isSearchBarFocused.value
                    ? const SizedBox()
                    : Container(
                        height: MediaQuery.of(context).size.width / 2 - 22,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppConst.mainBanner),
                            fit: BoxFit.cover,
                          ),
                          color: AppStyle.thirdColor,
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
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.white,
                                  height: MediaQuery.sizeOf(context).width / 12,
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Observer(
                                            builder: (context) => _controller
                                                    .isLoading.value
                                                ? const Text("0")
                                                : Text(
                                                    "${_controller.totalTeam.value}")),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .title),
                                      )
                                    ],
                                  )),
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

  Widget _contentBody(List<HomeClubModel> listFootballClub) {
    return Observer(builder: (_) {
      final width = MediaQuery.of(context).size.width;
      int crossAxisCount;

      // Determine the grid layout based on screen width
      if (width > 1200) {
        crossAxisCount = 8;
      } else if (width > 800) {
        crossAxisCount = 5;
      } else if (width > 600) {
        crossAxisCount = 3;
      } else {
        crossAxisCount = 2;
      }

      final displayList = _controller.searchQuery.value.isEmpty
          ? listFootballClub
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
          focusNode: _controller.searchBarFocusNode,
          onChanged: (value) {
            _controller.updateSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchHint,
            hintStyle: const TextStyle(color: Colors.white),
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

  Widget _itemCardFC(HomeClubModel footballClub) {
    final imageUrl = footballClub.badge ?? '';

    return GestureDetector(
      onTap: () {
        logger.i("id team is : ${footballClub.idTeam}");
        _controller.onTapItemFootBall(footballClub.team!);
      },
      child: Card(
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: AppStyle.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Hero(
                  tag: footballClub.team!,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Image.asset(
                      AppConst.clubLogoPlaceHolder,
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
            Expanded(
              flex: 1,
              child: Text(
                footballClub.team!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteCaller() {
    return GestureDetector(
      onTap: () {
        _controller.onTapFavScreen();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConst.imageBackground), fit: BoxFit.fill),
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
        ),
        child: const Icon(
          Icons.star_border,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget _settingsButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _controller.onTapSettingsScreen();
        },
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    );
  }
}
