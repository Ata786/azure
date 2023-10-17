import 'package:hive/hive.dart';

class DistributionModel {
  int? assignedId;
  int? distributorId;
  String? distributorName;

  DistributionModel({this.assignedId, this.distributorId, this.distributorName});

  DistributionModel.fromJson(Map<String, dynamic> json) {
    assignedId = json['assignedId'];
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assignedId'] = this.assignedId;
    data['distributorId'] = this.distributorId;
    data['distributorName'] = this.distributorName;
    return data;
  }
}



class DistributionModelAdapter extends TypeAdapter<DistributionModel> {
  @override
  final int typeId = 22; // Assign a unique ID for your type

  @override
  DistributionModel read(BinaryReader reader) {
    // Read data from the box and create a DistributionModel instance
    final assignedId = reader.readInt();
    final distributorId = reader.readInt();
    final distributorName = reader.readString();

    return DistributionModel(
      assignedId: assignedId,
      distributorId: distributorId,
      distributorName: distributorName,
    );
  }

  @override
  void write(BinaryWriter writer, DistributionModel obj) {
    // Write the DistributionModel instance to the box
    writer.writeInt(obj.assignedId ?? 0);
    writer.writeInt(obj.distributorId ?? 0);
    writer.writeString(obj.distributorName ?? "");
  }
}