import 'package:hive/hive.dart';

class MonthPerformanceModel {
  dynamic currentPjPShops;
  dynamic pjPShops;
  dynamic visitedShops;
  dynamic productiveShops;
  dynamic uniqueProductivety;
  dynamic noOfInvoices;
  dynamic averageDropSize;
  dynamic averageSale;
  dynamic frequency;
  dynamic lppc;
  List<BrandTonageSale> brandTonageSale = [];
  dynamic totalTonage;

  MonthPerformanceModel(
      {this.currentPjPShops,
        this.pjPShops,
        this.visitedShops,
        this.productiveShops,
        this.uniqueProductivety,
        this.noOfInvoices,
        this.averageDropSize,
        this.averageSale,
        this.frequency,
        this.lppc,
        required this.brandTonageSale,
        this.totalTonage});

  MonthPerformanceModel.fromJson(Map<dynamic, dynamic> json) {
    currentPjPShops = json['currentPjPShops'];
    pjPShops = json['pjPShops'];
    visitedShops = json['visitedShops'];
    productiveShops = json['productiveShops'];
    uniqueProductivety = json['uniqueProductivety'];
    noOfInvoices = json['noOfInvoices'];
    averageDropSize = json['averageDropSize'];
    averageSale = json['averageSale'];
    frequency = json['frequency'];
    lppc = json['lppc'];
    if (json['brandTonageSale'] != null) {
      if (json['brandTonageSale'] is List) {
        brandTonageSale = (json['brandTonageSale'] as List)
            .map((item) => BrandTonageSale.fromJson(item))
            .toList();
      } else if (json['brandTonageSale'] is Map) {
        brandTonageSale.add(BrandTonageSale.fromJson(json['brandTonageSale']));
      }
    }
    totalTonage = json['totalTonage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['currentPjPShops'] = this.currentPjPShops;
    data['pjPShops'] = this.pjPShops;
    data['visitedShops'] = this.visitedShops;
    data['productiveShops'] = this.productiveShops;
    data['uniqueProductivety'] = this.uniqueProductivety;
    data['noOfInvoices'] = this.noOfInvoices;
    data['averageDropSize'] = this.averageDropSize;
    data['averageSale'] = this.averageSale;
    data['frequency'] = this.frequency;
    data['lppc'] = this.lppc;
    if (this.brandTonageSale != null) {
      data['brandTonageSale'] = this.brandTonageSale!.map((item) => item.toJson()).toList();
    }
    data['totalTonage'] = this.totalTonage;
    return data;
  }
}

class BrandTonageSale {
  dynamic brandId;
  String? brandName;
  dynamic totalTonage;

  BrandTonageSale({this.brandId, this.brandName, this.totalTonage});

  BrandTonageSale.fromJson(Map<dynamic, dynamic> json) {
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



class MonthPerformanceModelAdapter extends TypeAdapter<MonthPerformanceModel> {
  @override
  final typeId = 3; // A unique ID for the adapter

  @override
  MonthPerformanceModel read(BinaryReader reader) {
    Map<dynamic, dynamic> map = reader.readMap();
    Map<String, dynamic> convertedMap = Map<String, dynamic>.from(map);
    return MonthPerformanceModel.fromJson(convertedMap);
  }

  @override
  void write(BinaryWriter writer, MonthPerformanceModel obj) {
    writer.writeMap(obj.toJson());
  }
}
