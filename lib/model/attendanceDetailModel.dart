class AttendanceDetailModel {
  String? id;
  String? fullName;
  String? designation;
  String? checkInTime;
  double? checkInLongitude;
  double? checkInLatitude;
  String? checkOutTime;
  double? checkOutLongitude;
  double? checkOutLatitude;
  String? checkIn;
  String? remarks;
  String? late;

  AttendanceDetailModel(
      {this.id,
        this.fullName,
        this.designation,
        this.checkInTime,
        this.checkInLongitude,
        this.checkInLatitude,
        this.checkOutTime,
        this.checkOutLongitude,
        this.checkOutLatitude,
        this.checkIn,
        this.remarks,
        this.late});

  AttendanceDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    designation = json['designation'];
    checkInTime = json['checkInTime'];
    checkInLongitude = json['checkInLongitude'];
    checkInLatitude = json['checkInLatitude'];
    checkOutTime = json['checkOutTime'];
    checkOutLongitude = json['checkOutLongitude'];
    checkOutLatitude = json['checkOutLatitude'];
    checkIn = json['checkIn'];
    remarks = json['remarks'];
    late = json['late'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['designation'] = this.designation;
    data['checkInTime'] = this.checkInTime;
    data['checkInLongitude'] = this.checkInLongitude;
    data['checkInLatitude'] = this.checkInLatitude;
    data['checkOutTime'] = this.checkOutTime;
    data['checkOutLongitude'] = this.checkOutLongitude;
    data['checkOutLatitude'] = this.checkOutLatitude;
    data['checkIn'] = this.checkIn;
    data['remarks'] = this.remarks;
    data['late'] = this.late;
    return data;
  }
}





  class AttendanceDetailsModel {
  String? id;
  String? fullName;
  String? designation;
  List<Attendance>? attendance;

    AttendanceDetailsModel({this.id, this.fullName, this.designation, this.attendance});

    AttendanceDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    designation = json['designation'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['designation'] = this.designation;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  String? attendanceId;
  String? checkInTime;
  dynamic checkInLongitude;
  dynamic checkInLatitude;
  dynamic checkOutTime;
  dynamic checkOutLongitude;
  dynamic checkOutLatitude;
  dynamic checkIn;
  dynamic remarks;
  String? late;

  Attendance(
      {this.attendanceId,
        this.checkInTime,
        this.checkInLongitude,
        this.checkInLatitude,
        this.checkOutTime,
        this.checkOutLongitude,
        this.checkOutLatitude,
        this.checkIn,
        this.remarks,
        this.late});

  Attendance.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendanceId'];
    checkInTime = json['checkInTime'];
    checkInLongitude = json['checkInLongitude'];
    checkInLatitude = json['checkInLatitude'];
    checkOutTime = json['checkOutTime'];
    checkOutLongitude = json['checkOutLongitude'];
    checkOutLatitude = json['checkOutLatitude'];
    checkIn = json['checkIn'];
    remarks = json['remarks'];
    late = json['late'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendanceId'] = this.attendanceId;
    data['checkInTime'] = this.checkInTime;
    data['checkInLongitude'] = this.checkInLongitude;
    data['checkInLatitude'] = this.checkInLatitude;
    data['checkOutTime'] = this.checkOutTime;
    data['checkOutLongitude'] = this.checkOutLongitude;
    data['checkOutLatitude'] = this.checkOutLatitude;
    data['checkIn'] = this.checkIn;
    data['remarks'] = this.remarks;
    data['late'] = this.late;
    return data;
  }
}