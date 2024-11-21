class EquipmentModel {
  String? idEquipment;
  String? idTeam;
  String? strSeason;
  String? strEquipment;
  String? type;

  EquipmentModel(
      {this.idEquipment,
      this.idTeam,
      this.strSeason,
      this.strEquipment,
      this.type});

  EquipmentModel.fromJson(Map<String, dynamic> json) {
    idEquipment = json['idEquipment'];
    idTeam = json['idTeam'];
    strSeason = json['strSeason'];
    strEquipment = json['strEquipment'];
    type = json['strType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEquipment'] = idEquipment;
    data['idTeam'] = idTeam;
    data['strSeason'] = strSeason;
    data['strEquipment'] = strEquipment;
    data['strType'] = type;
    return data;
  }
}
