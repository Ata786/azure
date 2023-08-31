import 'package:hive/hive.dart';

class ProductsModel {
  dynamic sr;
  dynamic rateId;
  String? pname;
  dynamic wgm;
  String? brandName;
  double? tonagePerPcs;
  dynamic retail;
  dynamic netRate;
  dynamic quantity;
  dynamic subTotal;
  dynamic weight;
  dynamic tonnage;
  dynamic fixedRate;

  ProductsModel(
      {this.sr,
        this.rateId,
        this.pname,
        this.wgm,
        this.brandName,
      this.tonagePerPcs,
      this.retail,
      this.netRate,
      this.quantity,
      this.subTotal,
      this.weight,
      this.tonnage,
        this.fixedRate
      });

  ProductsModel.fromJson(Map<dynamic, dynamic> json) {
    sr = json['sr'];
    rateId = json['rateId'];
    pname = json['pname'];
    wgm = json['wgm'];
    brandName = json['brandName'];
    tonagePerPcs = json['tonagePerPcs'];
    retail = json['retail'];
    netRate = json['netRate'];
    quantity = json['quantity'];
    subTotal = json['subTotal'];
    weight = json['weight'];
    tonnage = json['tonnage'];
    fixedRate = json['fixedRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['rateId'] = this.rateId;
    data['pname'] = this.pname;
    data['wgm'] = this.wgm;
    data['brandName'] = this.brandName;
    data['tonagePerPcs'] = this.tonagePerPcs;
    data['retail'] = this.retail;
    data['netRate'] = this.netRate;
    data['quantity'] = this.quantity;
    data['subTotal'] = this.subTotal;
    data['weight'] = this.weight;
    data['tonnage'] = this.tonnage;
    data['fixedRate'] = this.fixedRate;
    return data;
  }
}


class ProductsModelAdapter extends TypeAdapter<ProductsModel> {
  @override
  final int typeId = 5; // Unique identifier for this TypeAdapter

  @override
  ProductsModel read(BinaryReader reader) {
    return ProductsModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, ProductsModel obj) {
    writer.writeMap(obj.toJson());
  }
}