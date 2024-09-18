// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:radyadigital_bola/components/widget/app_observer_builder_widget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/model/club_model.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';
import 'package:premiere_league_v2/screens/detail/widget/favorite_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

// import '../model/player_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, this.data});
  final ClubModel? data;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DetailController(getIt.get(), widget.data!);
    _controller.dummyPlayerCommand.execute();
    _controller.favoriteCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: content(),
    );
  }

  PreferredSizeWidget appBar() => AppBar(
        title: Text(widget.data!.team!),
      );

  Widget content() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: <Widget>[
              headerDetail(),
              const SizedBox(
                height: 13,
              ),
              info(),
              const SizedBox(
                height: 13,
              ),
              mediaSocials(),
              const SizedBox(
                height: 13,
              ),
              contentDesc(),

              // not showing on the phone, yet
              // playerInfo()
            ],
          ),
        ),
      ),
    );
  }

  Widget headerDetail() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Center(
          child: Hero(
            tag: widget.data!.team!,
            child: Image.network(
              widget.data!.badge!,
              width: width / 1.5,
              height: height / 2.5,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          widget.data!.team!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width / 10),
        ),
        FavoriteButton(widget.data!, _controller),
      ],
    );
  }

  Widget info() {
    return Container(
      child: Column(
        children: [
          Text("Formed Year: ${widget.data!.formedYear}"),
          const SizedBox(
            height: 8,
          ),
          Text("Stadium: ${widget.data!.stadium!}")
        ],
      ),
    );
  }

  Widget mediaSocials() {
    return Container(
      child: Center(
        child: Column(
          children: [
            _mediaSocials(
                widget.data!.instagram!, Colors.pink, Ionicons.logo_instagram),
            _mediaSocials(
                widget.data!.youtube!, Colors.red, Ionicons.logo_youtube),
            _mediaSocials(
                widget.data!.facebook!, Colors.blue, Ionicons.logo_facebook),
          ],
        ),
      ),
    );
  }

  Widget _mediaSocials(String url, Color color, IconData icon) {
    if (url.isEmpty) {
      return Container();
    }
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(url),
      onTap: () async {
        final String finalUrl = "https://$url";
        finalUrl.toString();
        try {
          await _launchURL(finalUrl);
        } catch (e) {
          Logger().i(e.toString());
        }
      },
    );
  }

  Widget contentDesc() {
    return Center(
      child: Text(
        "Description: \n\n${widget.data!.desc!}",
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Not showing on the phone, yet

  // Widget playerInfo() {
  //   return AppObserverBuilder(
  //     commandQuery: _controller.dummyPlayerCommand,
  //     onLoading: () => _loading(),
  //     child: (data) => _contentPlayerBody(data),
  //   );
  // }

  // Widget _loading() => const Center(child: CircularProgressIndicator());

  // Widget _contentPlayerBody(List<PlayerModel> players) {
  //   return Container(
  //     height: 300,
  //     child: GridView.count(
  //       crossAxisCount: 3,
  //       childAspectRatio: 1.0,
  //       padding: const EdgeInsets.all(8.0),
  //       mainAxisSpacing: 3.0,
  //       crossAxisSpacing: 3.0,
  //       children: players.map((player) => _itemPlayer(player)).toList(),
  //     ),
  //   );
  // }

  // Widget _itemPlayer(PlayerModel player) {
  //   final playerImage = player.strThumb ?? '';

  //   return GridTile(child: CachedNetworkImage(imageUrl: playerImage));
  // }
}
