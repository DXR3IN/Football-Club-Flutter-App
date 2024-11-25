import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/components/widget/app_observer_builder_widget.dart';
import 'package:premiere_league_v2/components/util/hex_to_color.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/detail/controller/detail_controller.dart';
import 'package:premiere_league_v2/screens/detail/widget/favorite_button.dart';
import 'package:premiere_league_v2/screens/detail/presentation/detail_page.dart';
import 'package:premiere_league_v2/screens/detail/presentation/detail_shimmer_screen.dart';
import 'package:premiere_league_v2/screens/detail/presentation/history_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.team});
  final String team;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late final DetailController _controller;
  late final TabController _tabController;
  late final PageController _pageController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = DetailController();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _scrollController = ScrollController();

    // Sync PageView with TabBar
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
      }
    });

    // Fetch team and equipment details
    _controller.getTeamAndEquipment(widget.team);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: AppObserverBuilder(
        commandQuery: _controller.dummyDetailClubModel,
        onLoading: () => const DetailShimmerScreen(),
        onError: (error) => Center(child: Text('Error: $error')),
        child: (team) {
          _controller.teamFc.value = team;
          return _buildContent(team);
        },
      ),
      floatingActionButton: Observer(
        builder: (context) {
          final loading = _controller.isLoading.value;

          if (loading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: AppStyle.thirdColor,
              child: FloatingActionButton(
                onPressed: () {},
              ),
            );
          }

          final team = _controller.teamFc.value;

          if (team == ClubModel()) {
            return const SizedBox();
          }

          // Build the favorite button when the team is available
          return FavoriteButton(team);
        },
      ),
    );
  }

  Widget _buildContent(ClubModel team) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[_buildHeader(team)];
      },
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          _tabController.animateTo(value);
        },
        children: [
          DetailPage(team: team, controller: _controller),
          HistoryPage(
            idTeam: team.idTeam!,
          )
        ],
      ),
    );
  }

  Widget _buildHeader(ClubModel team) {
    return SliverAppBar(
      iconTheme: IconThemeData(color: hexToColor(team.colour3!)),
      backgroundColor: hexToColor(team.colour2!),
      expandedHeight: MediaQuery.sizeOf(context).width,
      pinned: true,
      snap: false,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 60),
        centerTitle: true,
        expandedTitleScale: 1.8,
        title: Text(
          team.team!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.sizeOf(context).width / 20,
            color: hexToColor(team.colour1!),
            shadows: [
              Shadow(
                offset: const Offset(1.0, 1.0),
                color: hexToColor(team.colour2!),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        background: Stack(
          children: [
            Container(
              color: Colors.grey[200],
            ),
            Container(
              height: (MediaQuery.sizeOf(context).width / 1.8) +
                  MediaQuery.paddingOf(context).top,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    hexToColor(team.colour1!),
                    hexToColor(team.colour2!),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Center(
                    child: Hero(
                      tag: team.team!,
                      child: CachedNetworkImage(
                        width: MediaQuery.sizeOf(context).width / 1.5,
                        imageUrl: team.badge!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Image.asset(
                          AppConst.clubLogoPlaceHolder,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).width / 4),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: _bottomTabBar(team),
    );
  }

  PreferredSizeWidget _bottomTabBar(ClubModel team) {
    return TabBar(
      controller: _tabController,
      dividerColor: hexToColor(team.colour1!),
      labelColor: AppStyle.primaryColor,
      automaticIndicatorColorAdjustment: true,
      unselectedLabelColor: hexToColor(team.colour1!),
      tabs: [
        Tab(text: AppLocalizations.of(context)!.detailTabTitle),
        Tab(text: AppLocalizations.of(context)!.eventsTabTitle),
      ],
      onTap: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}
