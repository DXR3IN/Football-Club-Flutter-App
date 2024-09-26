import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';

class FavoriteButton extends StatelessWidget {
  final ClubModel team;
  final DetailController _controller;
  const FavoriteButton(this.team, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool isFavorite = _controller.isFavorite.value;
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () async {
            await _controller.favoriteCommand.execute(team);
          },
        );
      },
    );
  }
}
