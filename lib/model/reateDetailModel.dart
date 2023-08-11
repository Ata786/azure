import 'package:hive/hive.dart';

class RateDetailModel {
  int? sr;
  String? ratename;
  List<RateDetail>? rateDetail;

  RateDetailModel(
      {this.sr,this.ratename,this.rateDetail});

  RateDetailModel.fromJson(Map<dynamic, dynamic> json) {
    sr = json['sr'];
    ratename = json['ratename'];
    if (json['rateDetail'] != null) {
      rateDetail = <RateDetail>[];
      json['rateDetail'].forEach((v) {
        rateDetail!.add(new RateDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['ratename'] = this.ratename;
    if (this.rateDetail != null) {
      data['rateDetail'] = this.rateDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RateDetail {
  dynamic sr;
  dynamic productId;
  dynamic stock;
  dynamic netRate;
  dynamic rateId;
  dynamic consumerPrice;

  RateDetail(
      {this.sr,
        this.productId,
        this.stock,
        this.netRate,
      this.rateId,
      this.consumerPrice});

  RateDetail.fromJson(Map<dynamic, dynamic> json) {
    sr = json['sr'];
    productId = json['productId'];
    stock = json['stock'];
    netRate = json['netRate'];
    rateId = json['rateId'];
    consumerPrice = json['consumerPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['productId'] = this.productId;
    data['stock'] = this.stock;
    data['netRate'] = this.netRate;
    data['rateId'] = this.rateId;
    data['consumerPrice'] = this.consumerPrice;
    return data;
  }
}

class RateDetailModelAdapter extends TypeAdapter<RateDetailModel> {
  @override
  final typeId = 9; // Unique identifier for this type

  @override
  RateDetailModel read(BinaryReader reader) {
    return RateDetailModel(
      sr: reader.read(),
      ratename: reader.read(),
      rateDetail: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, RateDetailModel obj) {
    writer.write(obj.sr);
    writer.write(obj.ratename);
    writer.write(obj.rateDetail);
  }
}

class RateDetailAdapter extends TypeAdapter<RateDetail> {
  @override
  final typeId = 10; // Unique identifier for this type

  @override
  RateDetail read(BinaryReader reader) {
    return RateDetail(
      sr: reader.read(),
      productId: reader.read(),
      stock: reader.read(),
      netRate: reader.read(),
      rateId: reader.read(),
      consumerPrice: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, RateDetail obj) {
    writer.write(obj.sr);
    writer.write(obj.productId);
    writer.write(obj.stock);
    writer.write(obj.netRate);
    writer.write(obj.rateId);
    writer.write(obj.consumerPrice);
  }
}