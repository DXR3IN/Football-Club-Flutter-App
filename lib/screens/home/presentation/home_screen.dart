import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ionicons/ionicons.dart';
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
  final _controller = HomeController();

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

    return SliverToBoxAdapter(
      child: Container(
        height: height,
        color: AppStyle.primaryColor,
      ),
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
    return CustomScrollView(
      controller: _controller.scrollController,
      slivers: <Widget>[
        _safeAreaWidget(context),
        _navBar(),
        SliverPadding(
          padding: AppStyle.mainPadding,
          sliver: AppObserverBuilder(
            commandQuery: _controller.listFootballClubCommand,
            onLoading: () =>
                const SliverToBoxAdapter(child: HomeShimmerScreen()),
            child: (data) {
              return _contentBody(data);
            },
          ),
        ),
      ],
    );
  }

  Widget _navBar() {
    return Observer(
        builder: (context) => SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              toolbarHeight: 60,
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: _controller.isSearchBarFocused.value
                  ? MediaQuery.of(context).size.width / 4
                  : MediaQuery.of(context).size.width / 1.3,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [_searchBar(), _settingsButton()],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      color: Colors.grey[200],
                    ),
                    _controller.isSearchBarFocused.value
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.width / 4,
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
                      padding: const EdgeInsets.only(
                          top: 50, right: 12, left: 12, bottom: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 40),
                            child: _controller.isSearchBarFocused.value
                                ? const SizedBox()
                                : Container(
                                    height:
                                        MediaQuery.of(context).size.width / 2 -
                                            22,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(AppConst.mainBanner),
                                        fit: BoxFit.cover,
                                      ),
                                      color: AppStyle.thirdColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          spreadRadius: 1.0,
                                          offset: Offset(-3, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(-3, -3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Observer(
                        builder: (context) => RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: _controller.totalTeam.value.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppStyle.primaryColor,
                                  ),
                                ),
                                const TextSpan(text: " "),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.title,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
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
      if (_controller.filteredTeams.isEmpty) {
        return SliverToBoxAdapter(
            child: SizedBox(
                height: (MediaQuery.sizeOf(context).height / 3) * 2,
                child: const Center(child: Text('No data'))));
      }
      return SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
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
            hintStyle: const TextStyle(color: AppStyle.thirdColor),
            fillColor: AppStyle.thirdColor,
            iconColor: AppStyle.thirdColor,
            focusColor: AppStyle.thirdColor,
            prefixIcon: const Icon(
              Icons.search,
              color: AppStyle.thirdColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: AppStyle.thirdColor, width: 2.0),
            ),
          ),
          cursorColor: AppStyle.thirdColor,
          style: const TextStyle(color: AppStyle.thirdColor),
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
          side: const BorderSide(width: 1, color: AppStyle.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                // flex: 5,
                child: Hero(
                  tag: footballClub.team!,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Image.asset(
                      AppConst.clubLogoPlaceHolder,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.fill,
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
          Ionicons.heart,
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
