class OfficeCodeModel {
  int? sr;
  String? ccode;
  String? cname;
  String? path;
  String? image;
  bool? isCode;

  OfficeCodeModel({this.sr, this.ccode, this.cname, this.path, this.image,this.isCode});

  OfficeCodeModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    ccode = json['ccode'];
    cname = json['cname'];
    path = json['path'];
    image = json['image'];
    isCode = json['isCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['ccode'] = this.ccode;
    data['cname'] = this.cname;
    data['path'] = this.path;
    data['image'] = this.image;
    return data;
  }
}