class LeagueModel {
  String? league;
  String? leagueAlternate;
  String? badge;
  String? logo;
  String? formedYear;
  String? country;

  LeagueModel({
    this.league,
    this.leagueAlternate,
    this.badge,
    this.logo,
    this.formedYear,
    this.country,
  });

  LeagueModel.fromJson(Map<String, dynamic> json) {
    league = json['strLeague'];
    leagueAlternate = json['strLeagueAlternate'];
    badge = json['strBadge'];
    logo = json['strLogo'];
    formedYear = json['intFormedYear'];
    country = json['strCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['league'] = league;
    data['leagueAlternate'] = leagueAlternate;
    data['badge'] = badge;
    data['logo'] = logo;
    data['formedYear'] = formedYear;
    data['country'] = country;
    return data;
  }
}
