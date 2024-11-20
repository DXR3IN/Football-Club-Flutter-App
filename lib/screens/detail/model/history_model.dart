class HistoryModel {
  String? homeTeam;
  String? awayTeam;

  String? homeTeamBadge;
  String? awayTeamBadge;

  String? homeScore;
  String? awayScore;

  String? dateEvent;

  HistoryModel(
      {this.homeTeam,
      this.awayTeam,
      this.homeTeamBadge,
      this.awayTeamBadge,
      this.homeScore,
      this.awayScore,
      this.dateEvent});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    homeTeam = json['strHomeTeam'] as String?;
    awayTeam = json['strAwayTeam'] as String?;
    homeTeamBadge = json['strHomeTeamBadge'] as String?;
    awayTeamBadge = json['strAwayTeamBadge'] as String?;
    homeScore = json['intHomeScore'] as String?;
    awayScore = json['intAwayScore'] as String?;
    dateEvent = json['dateEventLocal'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['strHomeTeam'] = homeTeam;
    data['strAwayTeam'] = awayTeam;
    data['strHomeTeamBadge'] = homeTeamBadge;
    data['strAwayTeamBadge'] = awayTeamBadge;
    data['intHomeScore'] = homeScore;
    data['intAwayScore'] = awayScore;
    data['dateEventLocal'] = dateEvent;
    return data;
  }
}
