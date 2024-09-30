import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/favorite/controller/favorite_controller.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:premiere_league_v2/screens/home/controller/home_controller.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteController _favoriteController =
      FavoriteController(getIt.get());
  final HomeController _controller = HomeController(getIt.get());

  @override
  void initState() {
    super.initState();
    _favoriteController.favoriteCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _contentBody(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text("Favorite Teams"),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          AppNav.navigator.pushNamedAndRemoveUntil(
            AppRoute.teamFcListScreen,
            (route) => false,
          );
        },
      ),
    );
  }

  Widget _contentBody() {
    return AppObserverBuilder(
      commandQuery: _favoriteController.favoriteCommand,
      onLoading: () => const Center(child: CircularProgressIndicator()),
      child: (data) {
        final List<FavClubModel> team = List<FavClubModel>.from(data);

        if (team.isEmpty) {
          return const Center(child: Text("No favorite teams yet"));
        }

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(8.0),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: team.map((team) => _itemCardFC(team)).toList(),
        );
      },
    );
  }

  Widget _itemCardFC(FavClubModel footballClub) {
    final imageUrl = footballClub.badge ?? '';

    return GestureDetector(
      onTap: () => _onTapItemFootball(footballClub),
      child: Stack(
        children: [
          Container(
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
                    tag: footballClub.team ?? 'default-tag',
                    child: CachedNetworkImage(
                      width: 120,
                      height: 120,
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      footballClub.team!,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  _favoriteController.removeFromFavorites(footballClub),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapItemFootball(FavClubModel team) {
    if (team.team != null && team.badge != null) {
      _controller.onTapItemFootBall(team.team!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load team details')),
      );
    }
  }
}
