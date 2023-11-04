import 'package:hive/hive.dart';

class UserLiveModel {
  String? email;
  String? dateTime;
  double? latitude;
  double? longitude;

  UserLiveModel({this.email, this.dateTime, this.latitude, this.longitude});

  UserLiveModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    dateTime = json['dateTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['dateTime'] = this.dateTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}




class UserLiveModelAdapter extends TypeAdapter<UserLiveModel> {
  @override
  final typeId = 25; // Unique identifier for this type

  @override
  UserLiveModel read(BinaryReader reader) {
    return UserLiveModel(
      email: reader.readString(),
      dateTime: reader.readString(),
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, UserLiveModel obj) {
    writer.writeString(obj.email ?? '');
    writer.writeString(obj.dateTime ?? '');
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeDouble(obj.latitude ?? 0.0);
  }
}