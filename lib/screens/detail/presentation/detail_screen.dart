import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';
import 'package:premiere_league_v2/components/widget/favorite_button/favorite_button.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.team, required this.idTeam});
  final String team;
  final String idTeam;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DetailController(getIt.get());
    _controller.dummyEquipmentCommand.execute(widget.idTeam);
    _controller.dummyDetailClubModel.execute(widget.team);
    // _controller.favoriteCommand.execute(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: AppObserverBuilder(
        commandQuery: _controller.dummyDetailClubModel,
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text('Error: $error')),
        child: (team) => _buildContent(team),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.favorite),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Detail Club"),
      centerTitle: true,
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
            const SizedBox(height: 20),
            _buildEquipmentObserver(),
            const SizedBox(height: 20),
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
      color: Colors.white,
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: team.banner!,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(team.desc!),
          )
        ],
      ),
    );
  }

  Widget _buildEquipmentObserver() {
    return SizedBox(
      height: 200,
      child: AppObserverBuilder(
        commandQuery: _controller.dummyEquipmentCommand,
        onLoading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        onError: (message) => Container(
          color: Colors.red,
          child: Center(
            child: Text(message),
          ),
        ),
        child: (equipmentData) {
          // Log the data type to check if it's what you expect
          logger.i("EquipmentData is ${equipmentData.runtimeType}");

          // Check if the data is null or empty
          if (equipmentData == null || equipmentData.isEmpty) {
            logger.i(
                "Equipment is $equipmentData and runtimeType ${equipmentData.runtimeType}");
            return const Center(child: Text("No equipment available"));
          }

          // Cast to the expected type (e.g., List<EquipmentModel>)
          var equipmentList = equipmentData as List<EquipmentModel>;

          logger.i("Equipment list has ${equipmentList.length} items");

          return GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1),
            itemCount: equipmentList.length, // Use the length of the list
            itemBuilder: (BuildContext context, int index) {
              var equipment = equipmentList[index];
              logger.i("Equipment item at index $index is ${equipment}");
              return Stack(children: [
                CachedNetworkImage(
                  imageUrl: equipment.strEquipment!,
                  fit: BoxFit.cover,
                ),
                Text(
                  equipment.strSeason!,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
                )
              ]);
            },
          );
        },
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
