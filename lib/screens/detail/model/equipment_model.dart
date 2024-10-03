class EquipmentModel {
  String? strSeason;
  String? strEquipment;

  EquipmentModel({this.strSeason, this.strEquipment});

  EquipmentModel.fromJson(Map<String, dynamic> json) {
    strSeason = json['strSeason'];
    strEquipment = json['strEquipment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['strSeason'] = strSeason;
    data['strEquipment'] = strEquipment;
    return data;
  }
}
