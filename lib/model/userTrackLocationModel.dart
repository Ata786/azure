class UserTrackLocationModel {
  String? sr;
  String? email;
  double? longitude;
  double? latitude;
  String? datetime;

  UserTrackLocationModel(
      {this.sr, this.email, this.longitude, this.latitude, this.datetime});

  UserTrackLocationModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    email = json['email'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['email'] = this.email;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['datetime'] = this.datetime;
    return data;
  }
}