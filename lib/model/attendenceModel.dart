import 'package:hive/hive.dart';

class CheckIn {
  String? userId = "";
  double? longitude = 0.0;
  double? latitude = 0.0;
  String? date = '00:00';

  CheckIn({this.userId, this.longitude, this.latitude, this.date});

  CheckIn.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['date'] = this.date;
    return data;
  }
}



class CheckOut {
  String? userId;
  double? longitude;
  double? latitude;
  String? date;

  CheckOut({this.userId, this.longitude, this.latitude, this.date});

  CheckOut.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['date'] = this.date;
    return data;
  }
}


class CheckInAdapter extends TypeAdapter<CheckIn> {
  @override
  final typeId = 20; // Unique identifier for this type

  @override
  CheckIn read(BinaryReader reader) {
    return CheckIn(
      userId: reader.readString(),
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      date: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckIn obj) {
    writer.writeString(obj.userId ?? '');
    writer.writeDouble(obj.longitude!);
    writer.writeDouble(obj.latitude!);
    writer.writeString(obj.date!);
  }
}



class CheckOutAdapter extends TypeAdapter<CheckOut> {
  @override
  final typeId = 21; // Unique identifier for this type

  @override
  CheckOut read(BinaryReader reader) {
    return CheckOut(
      userId: reader.readString(),
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      date: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckOut obj) {
    writer.writeString(obj.userId!);
    writer.writeDouble(obj.longitude!);
    writer.writeDouble(obj.latitude!);
    writer.writeString(obj.date!);
  }
}