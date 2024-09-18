class PlayerModel {
  String? strPlayer;
  String? strThumb;
  String? strWage;
  String? strHeight;
  String? strWeight;

  PlayerModel({this.strPlayer, this.strThumb, this.strHeight, this.strWeight});

  PlayerModel.fromJson(Map<String, dynamic> json) {
    strPlayer = json['strPlayer'];
    strThumb = json['strThumb'];
    strWage = json['strWage'];
    strHeight = json['strHeight'];
    strWeight = json['strWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['player'] = strPlayer;
    data['thumb'] = strThumb;
    data['wage'] = strWage;
    data['height'] = strHeight;
    data['height'] = strWeight;
    return data;
  }
}
