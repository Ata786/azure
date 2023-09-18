class UserModel {
  String? id;
  String? email;
  String? fullName;
  String? userType;
  String? designation;
  int? catagoryId;
  int? pjpId;
  dynamic attendance;
  bool? isLogin;

  UserModel(
      {this.id,
        this.email,
        this.fullName,
        this.userType,
        this.designation,
        this.catagoryId,
        this.attendance,
        this.pjpId,
      this.isLogin});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    userType = json['userType'];
    designation = json['designation'];
    catagoryId = json['catagoryId'];
    attendance = json['attendance'] ?? "";
    isLogin = json['isLogin'];
    pjpId = json['pjpId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['userType'] = this.userType;
    data['designation'] = this.designation;
    data['catagoryId'] = this.catagoryId;
    data['attendance'] = this.attendance;
    data['pjpId'] = this.pjpId;
    return data;
  }


}