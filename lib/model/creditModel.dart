import 'package:hive/hive.dart';

class CreditModel {
  int? sr;
  String? recieveableDate;
  int? pjpNoId;
  int? vanId;
  int? bookerId;
  String? type;
  int? shopId;
  int? billNoId;
  String? chequeNo;
  String? chequeDate;
  int? bankId;
  double? billAmount;
  int? companyId;
  int? realisedAmount;
  bool? isBounced;
  bool? isRecovered;
  String? bouncedDate;
  int? currentDistId;
  double? recovery;

  CreditModel(
      {this.sr,
        this.recieveableDate,
        this.pjpNoId,
        this.vanId,
        this.bookerId,
        this.type,
        this.shopId,
        this.billNoId,
        this.chequeNo,
        this.chequeDate,
        this.bankId,
        this.billAmount,
        this.companyId,
        this.realisedAmount,
        this.isBounced,
        this.isRecovered,
        this.bouncedDate,
        this.currentDistId,
        this.recovery
      });

  CreditModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    recieveableDate = json['recieveableDate'];
    pjpNoId = json['pjpNoId'];
    vanId = json['vanId'];
    bookerId = json['bookerId'];
    type = json['type'];
    shopId = json['shopId'];
    billNoId = json['billNoId'];
    chequeNo = json['chequeNo'];
    chequeDate = json['chequeDate'];
    bankId = json['bankId'];
    billAmount = json['billAmount'];
    companyId = json['companyId'];
    realisedAmount = json['realisedAmount'];
    isBounced = json['isBounced'];
    isRecovered = json['isRecovered'];
    bouncedDate = json['bouncedDate'];
    currentDistId = json['currentDistId'];
    recovery = json['recovery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['recieveableDate'] = this.recieveableDate;
    data['pjpNoId'] = this.pjpNoId;
    data['vanId'] = this.vanId;
    data['bookerId'] = this.bookerId;
    data['type'] = this.type;
    data['shopId'] = this.shopId;
    data['billNoId'] = this.billNoId;
    data['chequeNo'] = this.chequeNo;
    data['chequeDate'] = this.chequeDate;
    data['bankId'] = this.bankId;
    data['billAmount'] = this.billAmount;
    data['companyId'] = this.companyId;
    data['realisedAmount'] = this.realisedAmount;
    data['isBounced'] = this.isBounced;
    data['isRecovered'] = this.isRecovered;
    data['bouncedDate'] = this.bouncedDate;
    data['currentDistId'] = this.currentDistId;
    data['recovery'] = this.recovery;
    return data;
  }
}


class CreditModelAdapter extends TypeAdapter<CreditModel> {
  @override
  final typeId = 19; // Unique identifier for this type

  @override
  CreditModel read(BinaryReader reader) {
    return CreditModel(
      sr: reader.read(),
      recieveableDate: reader.read(),
      pjpNoId: reader.read(),
      vanId: reader.read(),
      bookerId: reader.read(),
      type: reader.read(),
      shopId: reader.read(),
      billNoId: reader.read(),
      chequeNo: reader.read(),
      chequeDate: reader.read(),
      bankId: reader.read(),
      billAmount: reader.read(),
      companyId: reader.read(),
      realisedAmount: reader.read(),
      isBounced: reader.read(),
      isRecovered: reader.read(),
      bouncedDate: reader.read(),
      currentDistId: reader.read(),
      recovery: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CreditModel obj) {
    writer.write(obj.sr);
    writer.write(obj.recieveableDate);
    writer.write(obj.pjpNoId);
    writer.write(obj.vanId);
    writer.write(obj.bookerId);
    writer.write(obj.type);
    writer.write(obj.shopId);
    writer.write(obj.billNoId);
    writer.write(obj.chequeNo);
    writer.write(obj.chequeDate);
    writer.write(obj.bankId);
    writer.write(obj.billAmount);
    writer.write(obj.companyId);
    writer.write(obj.realisedAmount);
    writer.write(obj.isBounced);
    writer.write(obj.isRecovered);
    writer.write(obj.bouncedDate);
    writer.write(obj.currentDistId);
    writer.write(obj.recovery);
  }
}