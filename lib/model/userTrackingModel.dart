import 'package:SalesUp/view/userTracking.dart';

import 'package:SalesUp/view/userTracking.dart';

import 'package:SalesUp/view/userTracking.dart';

class UserTrackingModel {
  String? id;
  String? fullName;
  String? email;
  String? designation;

  UserTrackingModel({this.id, this.fullName, this.email, this.designation});

  UserTrackingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['designation'] = this.designation;
    return data;
  }
}