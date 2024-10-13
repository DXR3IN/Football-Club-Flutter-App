import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/components/widget/favorite_button/favorite_button_controller.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';

class FavoriteButton extends StatefulWidget {
  final ClubModel footbalTeam;

  FavoriteButton(this.footbalTeam, {super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteButtonController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FavoriteButtonController(widget.footbalTeam);
    _controller.initializeFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        // Use the controller's favFootballTeam instead of re-initializing it
        bool isFavorite = _controller.isFavorite.value;

        logger.i("Favorite status is $isFavorite");
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () async {
            // Use the existing favFootballTeam from the controller
            await _controller.favoriteCommand
                .execute(_controller.favFootballTeam);
          },
        );
      },
    );
  }
}
