import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class SyncDownModel extends HiveObject implements Comparable<SyncDownModel> {
  @HiveField(0)
  String? shopname;

  @HiveField(1)
  String? address;

  @HiveField(2)
  String? salesInvoiceDate;

  @HiveField(3)
  String? gprs;

  @HiveField(4)
  int? shopCode;

  @HiveField(5)
  String? phone;

  @HiveField(6)
  String? owner;

  @HiveField(7)
  int? sr;

  @HiveField(7)
  int? catagoryId;

  SyncDownModel({this.shopname, this.address, this.salesInvoiceDate,this.gprs,this.shopCode,this.phone,this.owner,this.sr,this.catagoryId});

  SyncDownModel.fromJson(Map<String, dynamic> json) {
     shopname = json['shops']['shopname'] as String;
     address = json['shops']['address'] as String;
     salesInvoiceDate = json['shops']['salesInvoiceDate'] as String;
     gprs = json['shops']['gprs'] as String;
     shopCode = json['shops']['shopCode'] as int;
     phone = json['shops']['phone'] as String;
     owner = json['shops']['owner'] as String;
     sr = json['shops']['sr'] as int;
     catagoryId = json['catagoryId']['sr'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopname'] = this.shopname;
    data['address'] = this.address;
    data['salesInvoiceDate'] = this.salesInvoiceDate;
    data['gprs'] = this.gprs;
    data['shopCode'] = this.shopCode;
    data['phone'] = this.phone;
    data['owner'] = this.owner;
    data['sr'] = this.sr;
    data['catagoryId'] = this.catagoryId;
    return data;
  }

  @override
  int compareTo(SyncDownModel other) {
    return shopname!.compareTo(other.shopname!);
  }
}



class SyncDownModelAdapter extends TypeAdapter<SyncDownModel> {
  @override
  final int typeId = 0;

  @override
  SyncDownModel read(BinaryReader reader) {
    return SyncDownModel()
      ..shopname = reader.readString()
      ..address = reader.readString()
      ..salesInvoiceDate = reader.readString()
      ..gprs = reader.readString()
      ..shopCode = reader.readInt()
      ..phone = reader.readString()
      ..owner = reader.readString()
      ..sr = reader.readInt()
      ..catagoryId = reader.readInt();
  }

  @override
  void write(BinaryWriter writer, SyncDownModel obj) {
    writer.writeString(obj.shopname ?? '');
    writer.writeString(obj.address ?? '');
    writer.writeString(obj.salesInvoiceDate ?? '');
    writer.writeString(obj.gprs ?? '');
    writer.writeInt(obj.shopCode ?? 0);
    writer.writeString(obj.phone ?? '');
    writer.writeString(obj.owner ?? '');
    writer.writeInt(obj.sr ?? 0);
    writer.writeInt(obj.catagoryId ?? 0);
  }
}
