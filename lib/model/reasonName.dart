import 'package:hive/hive.dart';

class ReasonsModel {
  int? sr;
  String? reasonName;

  ReasonsModel({this.sr, this.reasonName});

  ReasonsModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    reasonName = json['reasonName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['reasonName'] = this.reasonName;
    return data;
  }
}


class ReasonsModelAdapter extends TypeAdapter<ReasonsModel> {
  @override
  final typeId = 7; // Unique identifier for this type

  @override
  ReasonsModel read(BinaryReader reader) {
    return ReasonsModel(
      sr: reader.readInt(),
      reasonName: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ReasonsModel obj) {
    writer.writeInt(obj.sr!);
    writer.writeString(obj.reasonName!);
  }
}






