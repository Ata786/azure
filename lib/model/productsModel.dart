import 'package:hive/hive.dart';

class ProductsModel {
  dynamic sr;
  String? pname;
  dynamic wgm;
  String? brandName;
  String? tonnageperpcs;
  dynamic retail;
  dynamic netRate;
  dynamic quantity;
  dynamic subTotal;

  ProductsModel(
      {this.sr,
        this.pname,
        this.wgm,
        this.brandName,
      this.tonnageperpcs,
      this.retail,
      this.netRate,
      this.quantity,
      this.subTotal});

  ProductsModel.fromJson(Map<dynamic, dynamic> json) {
    sr = json['sr'];
    pname = json['pname'];
    wgm = json['wgm'];
    brandName = json['brandName'];
    tonnageperpcs = json['tonnageperpcs'];
    retail = json['retail'];
    netRate = json['netRate'];
    quantity = json['quantity'];
    subTotal = json['subTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['pname'] = this.pname;
    data['wgm'] = this.wgm;
    data['brandName'] = this.brandName;
    data['tonnageperpcs'] = this.tonnageperpcs;
    data['retail'] = this.retail;
    data['netRate'] = this.netRate;
    data['quantity'] = this.quantity;
    data['subTotal'] = this.subTotal;
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