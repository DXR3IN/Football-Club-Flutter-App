import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/screens/maps/maps_screen.dart';

class GoogleMapsPopup {
  static Future<void> show(BuildContext context, String? location) async {
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
      builder: (context) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      color: Colors.grey,
                      child: MapsScreen(location: location)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
