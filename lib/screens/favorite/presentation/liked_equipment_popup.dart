import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:premiere_league_v2/screens/favorite/controller/favorite_controller.dart';
import 'package:premiere_league_v2/screens/favorite/model/liked_equipment_model.dart';

class LikedEquipmentPopup extends StatefulWidget {
  final FavoriteController controller;
  const LikedEquipmentPopup({super.key, required this.controller});

  @override
  State<LikedEquipmentPopup> createState() => _LikedEquipmentPopupState();
}

class _LikedEquipmentPopupState extends State<LikedEquipmentPopup> {
  @override
  void initState() {
    widget.controller.likedEquipmentCommand.execute();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigh = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        height: heigh / 1.5,
        margin: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: AppObserverBuilder(
            commandQuery: widget.controller.likedEquipmentCommand,
            onLoading: () => const Center(child: CircularProgressIndicator()),
            child: (data) {
              int crossAxisCount;
              if (width > 1200) {
                // Large screens (e.g., tablets or desktops)
                crossAxisCount = 8;
              } else if (width > 800) {
                // Medium screens (e.g., large phones)
                crossAxisCount = 5;
              } else if (width > 600) {
                crossAxisCount = 3;
              } else {
                // Small screens (e.g., regular phones)
                crossAxisCount = 2;
              }
              if (data.length == 0) {
                return SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.likedEquipment),
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final equipment = data[index];
                  return _equipmentCard(equipment);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _equipmentCard(LikedEquipmentModel equipment) {
    return Container(
      padding: const EdgeInsets.all(5),
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: equipment.imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              "assets/placeholder/equipment-placeholder.png",
            ),
          ),
          Center(
            child: Text(
              equipment.season!,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 32, 0, 83),
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    color: Colors.white,
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
