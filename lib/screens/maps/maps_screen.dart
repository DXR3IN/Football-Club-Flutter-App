import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premiere_league_v2/screens/maps/maps_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapsScreen extends StatefulWidget {
  final String? location;
  const MapsScreen({super.key, required this.location});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late MapsController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = MapsController();
    _controller.fetchCoordinates.execute(widget.location);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_controller.isLoading.value) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.white,
              child: Container(
                color: Colors.grey[300],
              ),
            ),
          );
        }
        if (_controller.locationCoordinates.value == null) {
          return const Center(child: Text("Location not found"));
        }

        return GoogleMap(

          initialCameraPosition: CameraPosition(
            target: _controller.locationCoordinates.value!,
            zoom: 12.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('team_location'),
              position: _controller.locationCoordinates.value!,
              infoWindow: InfoWindow(title: _controller.locationName.value),
            ),
          },
          onMapCreated: (controller) {},
        );
      },
    );
  }
}
