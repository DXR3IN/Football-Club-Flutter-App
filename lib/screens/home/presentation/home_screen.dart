import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/home/controller/home_controller.dart';
import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController(getIt.get());
  final TextEditingController _searchController = TextEditingController();
  List<HomeClubModel> _filteredTeams = [];

  @override
  void initState() {
    super.initState();
    _controller.dummyTeamFCCommand.execute();
    _searchController.addListener(() {
      final data = _controller.dummyTeamFCCommand.onData;
      if (data is List<HomeClubModel>) {
        _filterTeams(data);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTeams(List<HomeClubModel> listTeam) {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeams = listTeam
          .where((team) => team.team?.toLowerCase().contains(query) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      slivers: [
        _sliverAppBar(),
        _navBar(),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          sliver: AppObserverBuilder(
            commandQuery: _controller.dummyTeamFCCommand,
            onLoading: () => SliverToBoxAdapter(
                child: Container(height: 400, child: _loading())),
            child: (data) {
              return _contentBody(data);
            },
          ),
        ),
      ],
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/banner/premier-league-banner.jpg",
              fit: BoxFit.cover,
            ),
          ],
        ),
        title: Text(AppConst.appName),
        centerTitle: true,
      ),
    );
  }

  Widget _navBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [_searchBar(), _favorite()],
        ),
      ),
    );
  }

  Widget _contentBody(List<HomeClubModel> listTeam) {
    final displayList =
        _searchController.text.isEmpty ? listTeam : _filteredTeams;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _itemCardFC(displayList[index]);
        },
        childCount: displayList.length,
      ),
    );
  }

  Widget _searchBar() {
    return Expanded(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search teams...',
          fillColor: Colors.red,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _favorite() {
    return IconButton(
      icon: const Icon(Icons.favorite, color: Colors.red),
      onPressed: () {
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
          padding: const EdgeInsets.all(10),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Hero(
                  tag: footballClub.team!,
                  child: CachedNetworkImage(
                    width: 120,
                    height: 120,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => _loading(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Text(footballClub.team!),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading() => const Center(child: CircularProgressIndicator());
}
