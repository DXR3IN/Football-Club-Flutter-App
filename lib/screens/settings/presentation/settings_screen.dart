import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/screens/settings/controller/setting_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:premiere_league_v2/screens/settings/popup/change_language_popup.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = SettingController();

  @override
  void initState() {
    super.initState();
    _controller.initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: Column(
        children: [
          _header(),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppStyle.mainPadding,
          decoration: const BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.black))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Muhammad Irfan",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text("Github: DXR3IN")
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: AppStyle.mainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.languageSettingTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              Observer(
                builder: (context) {
                  return InkWell(
                    child: ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(_controller.isLang.value == 1
                            ? "English"
                            : "Indonesian"),
                        trailing: Icon(Icons.arrow_right_sharp)),
                    onTap: () async {
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
                        builder: (ctx) {
                          return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: ChangeLanguagePopup(
                                controller: _controller,
                              ));
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        // TripleWaveDesign()
      ],
    );
  }
}

class TripleWaveDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: CustomPaint(
        painter: VariedTripleWavePainter(),
      ),
    );
  }
}

class VariedTripleWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.blue[300]!;
    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.cubicTo(
      size.width * 0.2,
      40,
      size.width * 0.3,
      -30,
      size.width * 0.5,
      20,
    );
    path1.cubicTo(
      size.width * 0.7,
      60,
      size.width * 0.8,
      -10,
      size.width,
      30,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    canvas.drawPath(path1, paint);

    paint.color = Colors.blue[500]!;
    Path path2 = Path();
    path2.moveTo(0, 30);
    path2.cubicTo(
      size.width * 0.15,
      80,
      size.width * 0.4,
      -20,
      size.width * 0.55,
      50,
    );
    path2.cubicTo(
      size.width * 0.75,
      100,
      size.width * 0.85,
      20,
      size.width,
      70,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    canvas.drawPath(path2, paint);

    paint.color = Colors.blue[700]!;
    Path path3 = Path();
    path3.moveTo(0, 60);
    path3.cubicTo(
      size.width * 0.25,
      100,
      size.width * 0.5,
      -30,
      size.width * 0.7,
      80,
    );
    path3.cubicTo(
      size.width * 0.85,
      140,
      size.width,
      50,
      size.width,
      110,
    );
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
