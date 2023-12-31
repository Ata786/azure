import 'package:hive/hive.dart';

class OrderCalculationModel {
  int? shopId;
  double? bookingValue;
  double? llpc;
  double? qty;
  double? weight;
  double? tonnage;

  OrderCalculationModel({this.shopId,this.bookingValue, this.llpc, this.qty, this.weight,this.tonnage});

  OrderCalculationModel.fromJson(Map<String, dynamic> json) {
    shopId = json['shopId'];
    bookingValue = json['bookingValue'];
    llpc = json['llpc'];
    qty = json['qty'];
    weight = json['weight'];
    tonnage = json['tonnage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopId'] = this.shopId;
    data['bookingValue'] = this.bookingValue;
    data['llpc'] = this.llpc;
    data['qty'] = this.qty;
    data['weight'] = this.weight;
    data['tonnage'] = this.tonnage;
    return data;
  }
}


class OrderCalculationModelAdapter extends TypeAdapter<OrderCalculationModel> {
  @override
  final typeId = 17; // Unique identifier for this type

  @override
  OrderCalculationModel read(BinaryReader reader) {
    return OrderCalculationModel(
      shopId: reader.read(),
      bookingValue: reader.read(),
      llpc: reader.read(),
      qty: reader.read(),
      weight: reader.read(),
      tonnage: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderCalculationModel obj) {
    writer.write(obj.shopId);
    writer.write(obj.bookingValue);
    writer.write(obj.llpc);
    writer.write(obj.qty);
    writer.write(obj.weight);
    writer.write(obj.tonnage);
  }
}