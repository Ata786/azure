import 'package:hive/hive.dart';

class FinancialYearModel {
  int? id;
  int? value;

  FinancialYearModel({this.id, this.value});

  FinancialYearModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}



class FinancialYearAdapter extends TypeAdapter<FinancialYearModel> {
  @override
  final typeId = 23; // Unique identifier for this type

  @override
  FinancialYearModel read(BinaryReader reader) {
    final id = reader.readInt();
    final value = reader.readInt();
    return FinancialYearModel(id: id, value: value);
  }

  @override
  void write(BinaryWriter writer, FinancialYearModel obj) {
    writer.writeInt(obj.id ?? 0); // Use 0 as a default if id is null
    writer.writeInt(obj.value ?? 0); // Use 0 as a default if value is null
  }
}





