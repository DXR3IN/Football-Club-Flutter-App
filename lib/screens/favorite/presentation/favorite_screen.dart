import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/favorite/controller/favorite_controller.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:premiere_league_v2/screens/favorite/presentation/liked_equipment_popup.dart';
import 'package:premiere_league_v2/screens/home/controller/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavoriteController _favoriteController;
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _favoriteController = FavoriteController();

    _favoriteController.favoriteClubCommand.execute();

    _controller = HomeController(getIt.get());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _contentBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
            builder: (context) =>
                LikedEquipmentPopup(controller: _favoriteController),
          );
        },
        child: const Icon(Icons.rounded_corner_sharp),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.favoriteTitle),
      centerTitle: true,
    );
  }

  Widget _contentBody() {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (width > 1200) {
      crossAxisCount = 8;
    } else if (width > 800) {
      crossAxisCount = 5;
    } else if (width > 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }
    return AppObserverBuilder(
      commandQuery: _favoriteController.favoriteClubCommand,
      onLoading: () => const Center(child: CircularProgressIndicator()),
      child: (data) {
        final List<FavClubModel> team = List<FavClubModel>.from(data);

        if (team.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.favoriteError));
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Hero(
                      tag: footballClub.team ?? 'default-tag',
                      child: CachedNetworkImage(
                        height: 120,
                        width: 120,
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
        SnackBar(content: Text(AppLocalizations.of(context)!.unableToLoad)),
      );
    }
  }
}
