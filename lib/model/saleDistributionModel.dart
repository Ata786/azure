class SaleDistributionModel {
  List<BrandSale>? brandSale;
  List<CategorySale>? categorySale;
  List<Distributors>? distributors;
  List<RegionSale>? regionSale;

  SaleDistributionModel(
      {this.brandSale, this.categorySale, this.distributors, this.regionSale});

  SaleDistributionModel.fromJson(Map<String, dynamic> json) {
    if (json['brandSale'] != null) {
      brandSale = <BrandSale>[];
      json['brandSale'].forEach((v) {
        brandSale!.add(new BrandSale.fromJson(v));
      });
    }
    if (json['categorySale'] != null) {
      categorySale = <CategorySale>[];
      json['categorySale'].forEach((v) {
        categorySale!.add(new CategorySale.fromJson(v));
      });
    }
    if (json['distributors'] != null) {
      distributors = <Distributors>[];
      json['distributors'].forEach((v) {
        distributors!.add(new Distributors.fromJson(v));
      });
    }
    if (json['regionSale'] != null) {
      regionSale = <RegionSale>[];
      json['regionSale'].forEach((v) {
        regionSale!.add(new RegionSale.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brandSale != null) {
      data['brandSale'] = this.brandSale!.map((v) => v.toJson()).toList();
    }
    if (this.categorySale != null) {
      data['categorySale'] = this.categorySale!.map((v) => v.toJson()).toList();
    }
    if (this.distributors != null) {
      data['distributors'] = this.distributors!.map((v) => v.toJson()).toList();
    }
    if (this.regionSale != null) {
      data['regionSale'] = this.regionSale!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandSale {
  int? brandId;
  String? brandName;
  double? totalTonage;

  BrandSale({this.brandId, this.brandName, this.totalTonage});

  BrandSale.fromJson(Map<String, dynamic> json) {
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

class CategorySale {
  int? categoryId;
  String? categoryName;
  double? totalValue;

  CategorySale({this.categoryId, this.categoryName, this.totalValue});

  CategorySale.fromJson(Map<String, dynamic> json) {
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

class Distributors {
  int? distributorId;
  String? distributorName;
  String? townName;
  double? totalValue;

  Distributors(
      {this.distributorId,
        this.distributorName,
        this.townName,
        this.totalValue});

  Distributors.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    townName = json['townName'];
    totalValue = json['totalValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    data['townName'] = this.townName;
    data['totalValue'] = this.totalValue;
    return data;
  }
}

class RegionSale {
  int? regionId;
  String? regionName;
  double? totalValue;

  RegionSale({this.regionId, this.regionName, this.totalValue});

  RegionSale.fromJson(Map<String, dynamic> json) {
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