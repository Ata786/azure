import 'package:hive/hive.dart';

class CheckIn {
  String? id;
  String? userId;
  dynamic longitude;
  dynamic latitude;
  String? attendanceDateTime;
  dynamic outLongitude;
  dynamic outLatitude;
  String? outAttendanceDateTime;

  CheckIn(
      {this.id,
        this.userId,
        this.longitude,
        this.latitude,
        this.attendanceDateTime,
        this.outLongitude,
        this.outLatitude,
        this.outAttendanceDateTime,
});

  CheckIn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    attendanceDateTime = json['attendanceDateTime'];
    outLongitude = json['outLongitude'];
    outLatitude = json['outLatitude'];
    outAttendanceDateTime = json['outAttendanceDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['attendanceDateTime'] = this.attendanceDateTime;
    data['outLongitude'] = this.outLongitude;
    data['outLatitude'] = this.outLatitude;
    data['outAttendanceDateTime'] = this.outAttendanceDateTime;
    return data;
  }
}


class CheckOut {
  String? userId;
  dynamic outLongitude;
  dynamic outLatitude;
  String? outAttendanceDateTime;

  CheckOut({this.userId, this.outLongitude, this.outLatitude, this.outAttendanceDateTime});

  CheckOut.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    outLongitude = json['outLongitude'];
    outLatitude = json['outLatitude'];
    outAttendanceDateTime = json['outAttendanceDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['outLongitude'] = this.outLongitude;
    data['outLatitude'] = this.outLatitude;
    data['outAttendanceDateTime'] = this.outAttendanceDateTime;
    return data;
  }
}


class CheckInAdapter extends TypeAdapter<CheckIn> {
  @override
  final typeId = 20; // Unique identifier for this type

  @override
  CheckIn read(BinaryReader reader) {
    return CheckIn(
      id: reader.readString(),
      userId: reader.readString(),
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      attendanceDateTime: reader.readString(),
      outAttendanceDateTime: reader.readString(),
      outLatitude: reader.readDouble(),
      outLongitude: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckIn obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.userId ?? '');
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeDouble(obj.latitude ?? 0.0);
    writer.writeString(obj.attendanceDateTime ?? "");
    writer.writeString(obj.outAttendanceDateTime ?? "");
    writer.writeDouble(obj.outLatitude ?? 0.0);
    writer.writeDouble(obj.outLongitude ?? 0.0);
  }
}



class CheckOutAdapter extends TypeAdapter<CheckOut> {
  @override
  final typeId = 21; // Unique identifier for this type

  @override
  CheckOut read(BinaryReader reader) {
    return CheckOut(
      userId: reader.readString(),
      outLongitude: reader.readDouble(),
      outLatitude: reader.readDouble(),
      outAttendanceDateTime: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckOut obj) {
    writer.writeString(obj.userId!);
    writer.writeDouble(double.tryParse(obj.outLongitude!.toString())!);
    writer.writeDouble(double.tryParse(obj.outLatitude!.toString())!);
    writer.writeString(obj.outAttendanceDateTime!);
  }
}







class RemarksModel {
  String? remarks;
  String? checkIn;


  RemarksModel(
      {this.remarks,
        this.checkIn,

      });

  RemarksModel.fromJson(Map<String, dynamic> json) {
    remarks = json['remarks'];
    checkIn = json['checkIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remarks'] = this.remarks;
    data['checkIn'] = this.checkIn;
    return data;
  }
}



class RemarksModelAdapter extends TypeAdapter<RemarksModel> {
  @override
  final typeId = 24;

  @override
  RemarksModel read(BinaryReader reader) {
    return RemarksModel(
      remarks: reader.readString(),
      checkIn: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, RemarksModel obj) {
    writer.writeString(obj.remarks ?? "");
    writer.writeString(obj.checkIn ?? "");
  }
}


