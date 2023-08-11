import 'package:hive/hive.dart';

class CategoryNameModel {
  int? sr;
  String? name;

  CategoryNameModel({this.sr, this.name});

  CategoryNameModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['name'] = this.name;
    return data;
  }
}

class CategoryNameModelAdapter extends TypeAdapter<CategoryNameModel> {
  @override
  final typeId = 8; // Unique identifier for this type

  @override
  CategoryNameModel read(BinaryReader reader) {
    return CategoryNameModel(
      sr: reader.readInt(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryNameModel obj) {
    writer.writeInt(obj.sr!);
    writer.writeString(obj.name!);
  }
}