class DayCloseModel {
  int? distributorId;
  String? distributorName;
  String? dcdate;
  String? tname;

  DayCloseModel(
      {this.distributorId, this.distributorName, this.dcdate, this.tname});

  DayCloseModel.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    dcdate = json['dcdate'];
    tname = json['tname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    data['dcdate'] = this.dcdate;
    data['tname'] = this.tname;
    return data;
  }
}