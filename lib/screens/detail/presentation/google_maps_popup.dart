import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/screens/maps/maps_screen.dart';

class GoogleMapsPopup extends StatefulWidget {
  final String? location;
  const GoogleMapsPopup({super.key, required this.location});

  @override
  State<GoogleMapsPopup> createState() => _GoogleMapsPopupState();
}

class _GoogleMapsPopupState extends State<GoogleMapsPopup> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).width * 1.3,
        margin: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Column(
            children: [
              Center(
                  child: Container(
                height: 10,
                width: 100,
                decoration: BoxDecoration( 
                  color: AppStyle.primaryColor,
                  borderRadius: AppStyle.borderRadiusSmall(),
                ),
              )),
              const SizedBox(height: 12),
              Expanded(
                  flex: 5,
                  child: Container(
                    child: MapsScreen(location: widget.location),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
