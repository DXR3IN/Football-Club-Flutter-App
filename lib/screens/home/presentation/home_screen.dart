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
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(AppConst.appName),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Column(
      children: [
        _navBar(),
        Expanded(
          child: AppObserverBuilder(
            commandQuery: _controller.dummyTeamFCCommand,
            onLoading: () => _loading(),
            child: (data) {
              return _contentBody(data);
            },
          ),
        ),
      ],
    );
  }

  Widget _navBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [_searchBar(), _fovorite()],
      ),
    );
  }

  Widget _searchBar() {
    return Expanded(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search teams...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _fovorite() {
    return IconButton(
      icon: const Icon(Icons.favorite, color: Colors.red),
      onPressed: () {
        _controller.onTapFavScreen();
      },
    );
  }

  Widget _loading() => const Center(child: CircularProgressIndicator());

  Widget _contentBody(List<HomeClubModel> listTeam) {
    final displayList =
        _searchController.text.isEmpty ? listTeam : _filteredTeams;

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(8.0),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: displayList.map((team) => _itemCardFC(team)).toList(),
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
                child: CachedNetworkImage(
                  width: 120,
                  height: 120,
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
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
}
