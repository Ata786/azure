import 'package:intl/intl.dart';

class DaysModel {
  dynamic today;
  dynamic thisWeek;
  double? thisMonth;
  double? thisYear;
  List<BrandWiseModel>? brandSale;
  List<CategoryWiseModel>? categorySale;
  List<DistributedWiseModel>? distributors;
  List<RegionWiseModel>? regionSale;

  DaysModel({this.today, this.thisWeek, this.thisMonth, this.thisYear,this.brandSale,this.categorySale,this.distributors,this.regionSale});

  DaysModel.fromJson(Map<String, dynamic> json) {
    today = json['today'];
    thisWeek = json['thisWeek'];
    thisMonth = json['thisMonth'];
    thisYear = json['thisYear'];
    if (json['brandSale'] != null) {
      brandSale = [];
      json['brandSale'].forEach((v) {
        brandSale!.add(BrandWiseModel.fromJson(v));
      });
    }
    if (json['categorySale'] != null) {
      categorySale = [];
      json['categorySale'].forEach((v) {
        categorySale!.add(CategoryWiseModel.fromJson(v));
      });
    }
    if (json['distributors'] != null) {
      distributors = [];
      json['distributors'].forEach((v) {
        distributors!.add(DistributedWiseModel.fromJson(v));
      });
    }
    if (json['regionSale'] != null) {
      regionSale = [];
      json['regionSale'].forEach((v) {
        regionSale!.add(RegionWiseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['today'] = this.today;
    data['thisWeek'] = this.thisWeek;
    data['thisMonth'] = this.thisMonth;
    data['thisYear'] = this.thisYear;
    if(brandSale != null){
      data['brandSale'] = brandSale!.map((e) => e.toJson()).toList();
    }
    if(categorySale != null){
      data['categorySale'] = categorySale!.map((e) => e.toJson()).toList();
    }
    if(distributors != null){
      data['distributors'] = distributors!.map((e) => e.toJson()).toList();
    }
    if(regionSale != null){
      data['regionSale'] = regionSale!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}



class BrandWiseModel {
  int? brandId;
  String? brandName;
  double? totalTonage;

  BrandWiseModel({this.brandId, this.brandName, this.totalTonage});

  BrandWiseModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
    totalTonage = json['totalTonage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['totalTonage'] = this.totalTonage;
    return data;
  }
}


class CategoryWiseModel {
  int? categoryId;
  String? categoryName;
  dynamic totalValue;

  CategoryWiseModel({this.categoryId, this.categoryName, this.totalValue});

  CategoryWiseModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    totalValue = json['totalValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['totalValue'] = this.totalValue;
    return data;
  }
}


class DistributedWiseModel {
  int? distributorId;
  String? distributorName;
  dynamic totalValue;

  DistributedWiseModel({this.distributorId, this.distributorName, this.totalValue});

  DistributedWiseModel.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    totalValue = json['totalValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    data['totalValue'] = this.totalValue;
    return data;
  }
}




class RegionWiseModel {
  int? regionId;
  String? regionName;
  dynamic totalValue;

  RegionWiseModel({this.regionId, this.regionName, this.totalValue});

  RegionWiseModel.fromJson(Map<String, dynamic> json) {
    regionId = json['regionId'];
    regionName = json['regionName'];
    totalValue = json['totalValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regionId'] = this.regionId;
    data['regionName'] = this.regionName;
    data['totalValue'] = this.totalValue;
    return data;
  }
}