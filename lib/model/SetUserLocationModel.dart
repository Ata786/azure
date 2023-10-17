import 'package:hive/hive.dart';

class SetUserLocationModel {
  String? name;
  double? latitude;
  double? longitude;
  String? location;

  SetUserLocationModel({this.name, this.latitude, this.longitude, this.location});

  SetUserLocationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location'] = this.location;
    return data;
  }
}

class SetUserLocationModelHiveAdapter extends TypeAdapter<SetUserLocationModel> {
  @override
  final int typeId = 24;

  @override
  SetUserLocationModel read(BinaryReader reader) {
    final setUserLocationModel = SetUserLocationModel();
    setUserLocationModel.name = reader.readString();
    setUserLocationModel.latitude = reader.readDouble();
    setUserLocationModel.longitude = reader.readDouble();
    setUserLocationModel.location = reader.readString();
    return setUserLocationModel;
  }

  @override
  void write(BinaryWriter writer, SetUserLocationModel setUserLocationModel) {
    writer.writeString(setUserLocationModel.name ?? '');
    writer.writeDouble(setUserLocationModel.latitude ?? 0.0);
    writer.writeDouble(setUserLocationModel.longitude ?? 0.0);
    writer.writeString(setUserLocationModel.location ?? '');
  }
}