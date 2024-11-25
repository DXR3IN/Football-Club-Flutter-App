import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/screens/detail/widget/like_equipment_controller.dart';
import 'package:premiere_league_v2/screens/detail/model/equipment_model.dart';

class LikeEquipmentButton extends StatefulWidget {
  final EquipmentModel equipment;
  const LikeEquipmentButton({super.key, required this.equipment});

  @override
  State<LikeEquipmentButton> createState() => _LikeEquipmentButtonState();
}

class _LikeEquipmentButtonState extends State<LikeEquipmentButton> {
  late final LikeEquipmentController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = LikeEquipmentController(equipment: widget.equipment);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final isLiked = _controller.isLiked.value;
        return IconButton(
          icon: Icon(Icons.thumb_up,
              color: isLiked ? AppStyle.primaryColor : AppStyle.thirdColor),
          onPressed: () {
            _controller.toggleEquipmentCommand.execute();
          },
        );
      },
    );
  }
}
