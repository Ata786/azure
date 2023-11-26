import 'package:SalesUp/view/bookerWiseTarget.dart';

import 'package:SalesUp/view/bookerWiseTarget.dart';

import 'package:SalesUp/view/bookerWiseTarget.dart';

class BookerWiseTargetModel {
  String? bookerName;
  String? distributorName;
  dynamic totalTonnage;
  dynamic target;

  BookerWiseTargetModel(
      {this.bookerName, this.distributorName, this.totalTonnage, this.target});

  BookerWiseTargetModel.fromJson(Map<String, dynamic> json) {
    bookerName = json['bookerName'];
    distributorName = json['distributorName'];
    totalTonnage = json['totalTonnage'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookerName'] = this.bookerName;
    data['distributorName'] = this.distributorName;
    data['totalTonnage'] = this.totalTonnage;
    data['target'] = this.target;
    return data;
  }
}



class ShopWiseTargetModel {
  String? shopName;
  String? distributorName;
  dynamic targetTonnage;
  dynamic targetPcs;
  dynamic achTonnage;
  dynamic achPcs;

  ShopWiseTargetModel(
      {this.shopName,
        this.distributorName,
        this.targetTonnage,
        this.targetPcs,
        this.achTonnage,
        this.achPcs});

  ShopWiseTargetModel.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    distributorName = json['distributorName'];
    targetTonnage = json['targetTonnage'];
    targetPcs = json['targetPcs'];
    achTonnage = json['achTonnage'];
    achPcs = json['achPcs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['distributorName'] = this.distributorName;
    data['targetTonnage'] = this.targetTonnage;
    data['targetPcs'] = this.targetPcs;
    data['achTonnage'] = this.achTonnage;
    data['achPcs'] = this.achPcs;
    return data;
  }
}