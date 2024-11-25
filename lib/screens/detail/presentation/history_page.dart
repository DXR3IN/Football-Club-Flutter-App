import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/screens/detail/controller/history_controller.dart';
import 'package:premiere_league_v2/screens/detail/model/history_model.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends StatefulWidget {
  final String idTeam;
  const HistoryPage({super.key, required this.idTeam});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController(widget.idTeam);
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);

    String formattedDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(parsedDate);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AppObserverBuilder(
        commandQuery: _controller.getLastEventByIdCommand,
        onLoading: () => buildShimmer(),
        child: (events) {
          events = events as List<HistoryModel>;
          return ListView.builder(
            cacheExtent: 2,
            addAutomaticKeepAlives: true,
            padding: const EdgeInsets.all(10),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final HistoryModel event = events[index] as HistoryModel;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          formatDate(event.dateEvent!),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppStyle.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: AppStyle.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicWidth(
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: event.homeTeamBadge!,
                                  placeholder: (context, url) =>
                                      _appShimmer(child: Container()),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: num.parse(event.homeScore!) <=
                                              num.parse(event.awayScore!) ||
                                          num.parse(event.homeScore!) ==
                                              num.parse(event.awayScore!)
                                      ? const SizedBox()
                                      : const DecoratedBox(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppStyle.primaryColor),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Ionicons.trophy,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: "VS",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppStyle.primaryColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      children: [
                                        TextSpan(text: "${event.homeScore}"),
                                        const WidgetSpan(
                                          child: SizedBox(
                                            width: 5,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: "-",
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(
                                            width: 5,
                                          ),
                                        ),
                                        TextSpan(text: "${event.awayScore}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Trailing (Away Team Badge)
                          IntrinsicWidth(
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                    imageUrl: event.awayTeamBadge!),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: num.parse(event.homeScore!) >=
                                              num.parse(event.awayScore!) ||
                                          num.parse(event.homeScore!) ==
                                              num.parse(event.awayScore!)
                                      ? const SizedBox()
                                      : const DecoratedBox(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppStyle.primaryColor),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Ionicons.trophy,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: _appShimmer(
                  child: Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      )),
                )),
              ),
              _appShimmer(
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  height: 150,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Shimmer _appShimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: child,
    );
  }
}
