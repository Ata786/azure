import 'package:hive/hive.dart';

class RateDetailModel {
  int? productId;
  int? rateId;
  String? rateName;
  int? stock;
  double? netRate;
  double? consumerPrice;
  int? sr;

  RateDetailModel(
      {this.productId,
        this.rateId,
        this.rateName,
        this.stock,
        this.netRate,
        this.consumerPrice,
        this.sr});

  RateDetailModel.fromJson(Map<dynamic, dynamic> json) {
    productId = json['productId'];
    rateId = json['rateId'];
    rateName = json['rateName'];
    stock = json['stock'];
    netRate = json['netRate'];
    consumerPrice = json['consumerPrice'];
    sr = json['sr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['rateId'] = this.rateId;
    data['rateName'] = this.rateName;
    data['stock'] = this.stock;
    data['netRate'] = this.netRate;
    data['consumerPrice'] = this.consumerPrice;
    data['sr'] = this.sr;
    return data;
  }
}

class RateDetailModelAdapter extends TypeAdapter<RateDetailModel> {
  @override
  final int typeId = 9; // You need to choose a unique typeId for this class

  @override
  RateDetailModel read(BinaryReader reader) {
    return RateDetailModel(
      productId: reader.read(),
      rateId: reader.read(),
      rateName: reader.read(),
      stock: reader.read(),
      netRate: reader.read(),
      consumerPrice: reader.read(),
      sr: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, RateDetailModel obj) {
    writer.write(obj.productId);
    writer.write(obj.rateId);
    writer.write(obj.rateName);
    writer.write(obj.stock);
    writer.write(obj.netRate);
    writer.write(obj.consumerPrice);
    writer.write(obj.sr);
  }
}