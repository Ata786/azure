import 'package:hive/hive.dart';

class HistoryModel {
  int? sr;
  int? shopId;
  String? bookerId;
  int? checkIn;
  String? createdOn;
  String? image;
  String? payment;
  String? reason;

  HistoryModel(
      {this.sr,
      this.shopId,
      this.bookerId,
      this.checkIn,
      this.createdOn,
      this.image,
      this.payment,
      this.reason});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    shopId = json['shopId'];
    bookerId = json['bookerId'];
    checkIn = json['checkIn'];
    createdOn = json['createdOn'];
    image = json['image'];
    payment = json['payment'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['shopId'] = this.shopId;
    data['bookerId'] = this.bookerId;
    data['checkIn'] = this.checkIn;
    data['createdOn'] = this.createdOn;
    data['image'] = this.image;
    data['payment'] = this.payment;
    data['reason'] = this.reason;
    return data;
  }
}



class HistoryModelHiveAdapter extends TypeAdapter<HistoryModel> {
  @override
  final int typeId = 18; // Replace with a unique type ID for your model

  @override
  HistoryModel read(BinaryReader reader) {
    final historyModel = HistoryModel();
    historyModel.sr = reader.readInt();
    historyModel.shopId = reader.readInt();
    historyModel.bookerId = reader.readString();
    historyModel.checkIn = reader.readInt();
    historyModel.createdOn = reader.readString();
    historyModel.image = reader.readString();
    historyModel.payment = reader.readString();
    historyModel.reason = reader.readString();
    return historyModel;
  }

  @override
  void write(BinaryWriter writer, HistoryModel historyModel) {
    writer.writeInt(historyModel.sr ?? 0);
    writer.writeInt(historyModel.shopId ?? 0);
    writer.writeString(historyModel.bookerId ?? '');
    writer.writeInt(historyModel.checkIn ?? 0);
    writer.writeString(historyModel.createdOn ?? '');
    writer.writeString(historyModel.image ?? '');
    writer.writeString(historyModel.payment ?? '');
    writer.writeString(historyModel.reason ?? '');
  }
}
