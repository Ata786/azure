import 'package:hive/hive.dart';

class OrderCalculationModel {
  double? bookingValue;
  double? llpc;
  double? qty;

  OrderCalculationModel({this.bookingValue, this.llpc, this.qty});

  OrderCalculationModel.fromJson(Map<String, dynamic> json) {
    bookingValue = json['bookingValue'];
    llpc = json['llpc'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingValue'] = this.bookingValue;
    data['llpc'] = this.llpc;
    data['qty'] = this.qty;
    return data;
  }
}


class OrderCalculationModelAdapter extends TypeAdapter<OrderCalculationModel> {
  @override
  final typeId = 17; // Unique identifier for this type

  @override
  OrderCalculationModel read(BinaryReader reader) {
    return OrderCalculationModel(
      bookingValue: reader.read(),
      llpc: reader.read(),
      qty: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderCalculationModel obj) {
    writer.write(obj.bookingValue);
    writer.write(obj.llpc);
    writer.write(obj.qty);
  }
}