class LikedEquipmentModel {
  String? id;
  String? idTeam;
  String? season;
  String? imageUrl;

  LikedEquipmentModel(
      {this.id, this.idTeam, this.season, this.imageUrl});

  LikedEquipmentModel.fromJson(Map<String, dynamic> json) {
    id = json['idEquipment'];
    idTeam = json['idTeam'];
    season = json['strSeason'];
    imageUrl = json['strEquipment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEquipment'] = id;
    data['idTeam'] = idTeam;
    data['strSeason'] = season;
    data['strEquipment'] = imageUrl;
    return data;
  }
}
