class AttendenceModel {
  String? id;
  String? userId;
  double? longitude;
  double? latitude;
  String? attendanceDateTime;
  dynamic user;

  AttendenceModel(
      {this.id,
        this.userId,
        this.longitude,
        this.latitude,
        this.attendanceDateTime,
        this.user});

  AttendenceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    attendanceDateTime = json['attendanceDateTime'];
    user = json['user'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['attendanceDateTime'] = this.attendanceDateTime;
    data['user'] = this.user;
    return data;
  }
}