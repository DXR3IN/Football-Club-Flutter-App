class ClubModel {
  String? idTeam;
  String? team;
  String? teamAlternate;
  String? badge;
  String? banner;
  String? youtube;
  String? instagram;
  String? facebook;
  String? twitter;
  String? website;
  String? formedYear;
  String? league;
  String? stadium;
  String? desc;
  String? colour1;
  String? colour2;

  ClubModel(
      {this.idTeam,
      this.team,
      this.teamAlternate,
      this.badge,
      this.banner,
      this.youtube,
      this.instagram,
      this.facebook,
      this.twitter,
      this.website,
      this.formedYear,
      this.league,
      this.stadium,
      this.desc,
      this.colour1,
      this.colour2});

  ClubModel.fromJson(Map<String, dynamic> json) {
    idTeam = json['idTeam'] as String?;
    team = json['strTeam'] as String?;
    teamAlternate = json['strTeamAlternate'] as String?;
    badge = json['strBadge'] as String?;
    banner = json['strBanner'] as String?;
    youtube = json['strYoutube'] as String?;
    instagram = json['strInstagram'] as String?;
    facebook = json['strFacebook'] as String?;
    twitter = json['strTwitter'] as String?;
    website = json['strWebsite'] as String?;
    formedYear = json['intFormedYear']?.toString();
    league = json['strLeague'] as String?;
    stadium = json['strStadium'] as String?;
    desc = json['strDescriptionEN'] as String?;
    colour1 = json['strColour1'] as String?;
    colour2 = json['strColour2'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTeam'] = idTeam;
    data['strTeam'] = team;
    data['strTeamAlternate'] = teamAlternate;
    data['strBadge'] = badge;
    data['strBanner'] = banner;
    data['strYoutube'] = youtube;
    data['strInstagram'] = instagram;
    data['strFacebook'] = facebook;
    data['strTwitter'] = twitter;
    data['strWebsite'] = website;
    data['intFormedYear'] = formedYear;
    data['strLeague'] = league;
    data['strStadium'] = stadium;
    data['strDescriptionEN'] = desc;
    data['strColour1'] = colour1;
    data['strColour2'] = colour2;
    return data;
  }
}
