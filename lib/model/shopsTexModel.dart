import 'package:hive/hive.dart';

class ShopsStatusModel {
  int? sr;
  String? name;

  ShopsStatusModel({this.sr, this.name});

  ShopsStatusModel.fromJson(Map<String, dynamic> json) {
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


class ShopSectorModel {
  int? sr;
  String? name;
  String? nname;
  int? distributerId;

  ShopSectorModel({this.sr, this.name, this.nname, this.distributerId});

  ShopSectorModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    name = json['name'];
    nname = json['nname'];
    distributerId = json['distributerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['name'] = this.name;
    data['nname'] = this.nname;
    data['distributerId'] = this.distributerId;
    return data;
  }
}


class ShopTypeModel {
  int? sr;
  String? name;

  ShopTypeModel({this.sr, this.name});

  ShopTypeModel.fromJson(Map<String, dynamic> json) {
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


class ShopsStatusModelAdapter extends TypeAdapter<ShopsStatusModel> {

  @override
  final int typeId = 13;

  @override
  ShopsStatusModel read(BinaryReader reader) {
    return ShopsStatusModel(
      sr: reader.readInt(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopsStatusModel obj) {
    writer.writeInt(obj.sr ?? 0);
    writer.writeString(obj.name ?? '');
  }

}


class ShopTypeModelAdapter extends TypeAdapter<ShopTypeModel> {

  @override
  final int typeId = 14;

  @override
  ShopTypeModel read(BinaryReader reader) {
    return ShopTypeModel(
      sr: reader.readInt(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopTypeModel obj) {
    writer.writeInt(obj.sr ?? 0);
    writer.writeString(obj.name ?? '');
  }

}


class ShopSectorModelAdapter extends TypeAdapter<ShopSectorModel> {

  @override
  final int typeId = 15;
  @override
  ShopSectorModel read(BinaryReader reader) {
    return ShopSectorModel(
      sr: reader.readInt(),
      name: reader.readString(),
      nname: reader.readString(),
      distributerId: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopSectorModel obj) {
    writer.writeInt(obj.sr ?? 0);
    writer.writeString(obj.name ?? '');
    writer.writeString(obj.nname ?? '');
    writer.writeInt(obj.distributerId ?? 0);
  }
}


