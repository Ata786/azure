import 'package:hive/hive.dart';

class ReasonModel {
  String? shopId;
  int? bookerId;
  String? checkIn;
  String? createdOn;
  String? image;
  String? payment;
  String? reason;
  String? pjpnumber;
  String? shopName;

  ReasonModel(
      {this.shopId,
        this.bookerId,
        this.checkIn,
        this.createdOn,
        this.image,
        this.payment,
        this.reason,
        this.pjpnumber,
      this.shopName});

  ReasonModel.fromJson(Map<dynamic, dynamic> json) {
    shopId = json['shopId'];
    bookerId = json['bookerId'];
    checkIn = json['checkIn'];
    createdOn = json['createdOn'];
    image = json['image'];
    payment = json['payment'];
    reason = json['reason'];
    pjpnumber = json['pjpnumber'];
    shopName = json['shopName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopId'] = this.shopId;
    data['bookerId'] = this.bookerId;
    data['checkIn'] = this.checkIn;
    data['createdOn'] = this.createdOn;
    data['image'] = this.image;
    data['payment'] = this.payment;
    data['reason'] = this.reason;
    data['pjpnumber'] = this.pjpnumber;
    data['shopName'] = this.shopName;
    return data;
  }
}


class ReasonModelAdapter extends TypeAdapter<ReasonModel> {
  @override
  final int typeId = 6; // Unique identifier for this TypeAdapter

  @override
  ReasonModel read(BinaryReader reader) {
    return ReasonModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, ReasonModel obj) {
    writer.writeMap(obj.toJson());
  }
}