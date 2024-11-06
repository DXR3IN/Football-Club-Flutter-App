import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/screens/settings/controller/setting_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguagePopup extends StatefulWidget {
  final SettingController? controller;

  const ChangeLanguagePopup({super.key, this.controller});

  @override
  State<ChangeLanguagePopup> createState() => _ChangeLanguagePopupState();
}

class _ChangeLanguagePopupState extends State<ChangeLanguagePopup> {
  late SettingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        margin: MediaQuery.of(context).viewInsets,
        child: Observer(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 10,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0)),
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _customRadioButton(
                    child: Text(
                      AppLocalizations.of(context)!.english,
                      style: AppStyle.rSansw500,
                    ),
                    value: 1,
                    groupValue: _controller!.isLang.value,
                    onChanged: (int? value) {
                      _controller?.setIsLang(value ?? 1);
                      _controller?.saveLanguage(context);
                    },
                    size: 20.0,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  _customRadioButton(
                    child: Text(
                      AppLocalizations.of(context)!.indonesian,
                      style: AppStyle.rSansw500,
                    ),
                    value: 2,
                    groupValue: _controller!.isLang.value,
                    onChanged: (int? value) {
                      _controller?.setIsLang(value ?? 2);
                      _controller?.saveLanguage(context);
                    },
                    size: 20.0,
                  ),
                  // InkWell(
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 20,
                  //       vertical: 10,
                  //     ),
                  //     color: AppStyle.primaryColor,
                  //     child: Text(
                  //       "Change",
                  //       style: TextStyle(
                  //           color: const Color.fromRGBO(228, 227, 232, 1)),
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     _controller?.saveLanguage(context);
                  //   },
                  // ),
                  const SizedBox(
                    height: 37,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _customRadioButton(
      {required Widget child,
      required int value,
      required int groupValue,
      required Function(int) onChanged,
      required double size}) {
    final isSelected = value == groupValue;

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: () => onChanged(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: child,
              ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? AppStyle.primaryColor : AppStyle.thirdColor,
                    width: 2.0,
                  ),
                  color:
                      isSelected ? AppStyle.primaryColor : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: size / 1.8,
                          height: size / 1.8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyle.primaryColor,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
