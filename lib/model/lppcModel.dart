class LppcModel {
  List<DistributionList>? distributionList;
  List<BookerList>? bookerList;

  LppcModel({this.distributionList, this.bookerList});

  LppcModel.fromJson(Map<String, dynamic> json) {
    if (json['distributionList'] != null) {
      distributionList = <DistributionList>[];
      json['distributionList'].forEach((v) {
        distributionList!.add(new DistributionList.fromJson(v));
      });
    }
    if (json['bookerList'] != null) {
      bookerList = <BookerList>[];
      json['bookerList'].forEach((v) {
        bookerList!.add(new BookerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distributionList != null) {
      data['distributionList'] =
          this.distributionList!.map((v) => v.toJson()).toList();
    }
    if (this.bookerList != null) {
      data['bookerList'] = this.bookerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DistributionList {
  int? distributorId;
  String? distributorName;
  dynamic lppc;
  String? townName;

  DistributionList({this.distributorId, this.distributorName, this.lppc,this.townName});

  DistributionList.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    lppc = json['lppc'];
    townName = json['townName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    data['lppc'] = this.lppc;
    data['townName'] = this.townName;
    return data;
  }
}

class BookerList {
  int? distributorId;
  String? distributorName;
  String? bookerName;
  dynamic lppc;
  dynamic lppc2;

  BookerList(
      {this.distributorId,
        this.distributorName,
        this.bookerName,
        this.lppc,
        this.lppc2});

  BookerList.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    bookerName = json['bookerName'];
    lppc = json['lppc'];
    lppc2 = json['lppc2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    data['bookerName'] = this.bookerName;
    data['lppc'] = this.lppc;
    data['lppc2'] = this.lppc2;
    return data;
  }
}