import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/components/widget/favorite_button/favorite_button_controller.dart';

class FavoriteButton extends StatefulWidget {
  final ClubModel team;

  FavoriteButton(this.team, {super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteButtonController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FavoriteButtonController(widget.team.team);
    _controller.initializeFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool isFavorite = _controller.isFavorite.value;
        logger.i("Favorite data is ${isFavorite}");
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () async {
            await _controller.favoriteCommand.execute(widget.team);
          },
        );
      },
    );
  }
}
