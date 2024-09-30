import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';
import 'package:premiere_league_v2/components/widget/favorite_button/favorite_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.data});
  final String data;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DetailController(getIt.get());
    // _controller.dummyPlayerCommand.execute(widget.data);
    _controller.dummyDetailClubModel.execute(widget.data);
    // _controller.favoriteCommand.execute(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: AppObserverBuilder(
        commandQuery: _controller.dummyDetailClubModel,
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text('Error: $error')),
        child: (team) => _buildContent(team),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Detail Club"),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate to the main menu, clearing the current route stack
          AppNav.navigator.pushNamedAndRemoveUntil(
            AppRoute.teamFcListScreen,
            (route) => false,
          );
        },
      ),
    );
  }

  Widget _buildContent(ClubModel team) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildHeader(team),
            const SizedBox(height: 13),
            _buildInfo(team),
            const SizedBox(height: 13),
            _buildMediaSocials(team),
            const SizedBox(height: 13),
            _buildDescription(team),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ClubModel team) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Center(
          child: Hero(
            tag: team.team!,
            child: Image.network(
              team.badge!,
              width: width / 1.5,
              height: height / 2.5,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          team.team!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width / 10),
        ),
        FavoriteButton(team),
      ],
    );
  }

  Widget _buildInfo(ClubModel team) {
    return Column(
      children: [
        Text(
          "Formed Year: ${team.formedYear}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          "Stadium: ${team.stadium}",
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildMediaSocials(ClubModel team) {
    return Column(
      children: [
        _buildMediaItem(team.instagram!, Colors.pink, Ionicons.logo_instagram),
        _buildMediaItem(team.youtube!, Colors.red, Ionicons.logo_youtube),
        _buildMediaItem(team.facebook!, Colors.blue, Ionicons.logo_facebook),
      ],
    );
  }

  Widget _buildMediaItem(String url, Color color, IconData icon) {
    if (url.isEmpty) return const SizedBox();

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(url),
      onTap: () async {
        try {
          await _launchUrl("https://$url");
        } catch (e) {
          Logger().i("Failed to launch URL: $e");
        }
      },
    );
  }

  Widget _buildDescription(ClubModel team) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey[300],
      child: Text(
        "Description: \n\n${team.desc!}",
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
