class ReceivableModel {
  Today? today;
  Today? thisWeek;
  Today? thisMonth;
  Today? thisYear;
  List<Distributor>? distributor;

  ReceivableModel({this.today, this.thisWeek, this.thisMonth, this.thisYear,this.distributor});

  ReceivableModel.fromJson(Map<String, dynamic> json) {
    today = json['today'] != null ? new Today.fromJson(json['today']) : null;
    thisWeek =
    json['thisWeek'] != null ? new Today.fromJson(json['thisWeek']) : null;
    thisMonth = json['thisMonth'] != null
        ? new Today.fromJson(json['thisMonth'])
        : null;
    thisYear =
    json['thisYear'] != null ? new Today.fromJson(json['thisYear']) : null;
    if (json['distributor'] != null) {
      distributor = <Distributor>[];
      json['distributor'].forEach((v) {
        distributor!.add(new Distributor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.today != null) {
      data['today'] = this.today!.toJson();
    }
    if (this.thisWeek != null) {
      data['thisWeek'] = this.thisWeek!.toJson();
    }
    if (this.thisMonth != null) {
      data['thisMonth'] = this.thisMonth!.toJson();
    }
    if (this.thisYear != null) {
      data['thisYear'] = this.thisYear!.toJson();
    }
    if (this.distributor != null) {
      data['distributor'] = this.distributor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Today {
  dynamic reciveable;
  dynamic recovery;

  Today({this.reciveable, this.recovery});

  Today.fromJson(Map<String, dynamic> json) {
    reciveable = json['reciveable'];
    recovery = json['recovery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reciveable'] = this.reciveable;
    data['recovery'] = this.recovery;
    return data;
  }
}


class Distributor {
  int? distributorId;
  String? distributorName;
  double? totalReciveable;

  Distributor({this.distributorId, this.distributorName, this.totalReciveable});

  Distributor.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    totalReciveable = json['totalReciveable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    data['totalReciveable'] = this.totalReciveable;
    return data;
  }
}