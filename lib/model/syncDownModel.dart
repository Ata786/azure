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

  @HiveField(8)
  int? catagoryId;

  @HiveField(9)
  bool? productive;

  @HiveField(10)
  String? cnic;

  @HiveField(11)
  String? myntn;

  @HiveField(12)
  String? tax;

  @HiveField(13)
  int? typeId;

  @HiveField(14)
  int? sectorId;

  @HiveField(15)
  int? statusId;

  @HiveField(16)
  bool? isEdit;

  @HiveField(17)
  String? picture;

  SyncDownModel({this.shopname, this.address, this.salesInvoiceDate,this.gprs,this.shopCode,this.phone,this.owner,this.sr,this.catagoryId,this.productive,this.cnic,this.tax,this.myntn,this.sectorId,this.statusId,this.typeId,this.isEdit,this.picture});

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
     productive = json['productive'] as bool;
     tax = json['shops']['tax'] as String;
     myntn = json['shops']['myntn'] as String;
     cnic = json['shops']['cnic'] as String;
     typeId = json['shops']['typeId'] as int;
     sectorId = json['shops']['sectorId'] as int;
     statusId = json['shops']['statusId'] as int;
     statusId = json['shops']['picture'] as int;
     isEdit = json['isEdit'] as bool;
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
    data['productive'] = this.productive;
    data['cnic'] = this.cnic;
    data['myntn'] = this.myntn;
    data['isEdit'] = this.isEdit;
    data['tax'] = this.tax;
    data['sectorId'] = this.sectorId;
    data['typeId'] = this.typeId;
    data['statusId'] = this.statusId;
    data['picture'] = this.picture;
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
      ..catagoryId = reader.readInt()
      ..productive = reader.readBool()
      ..tax = reader.readString()
      ..cnic = reader.readString()
      ..myntn = reader.readString()
      ..statusId = reader.readInt()
      ..sectorId = reader.readInt()
      ..typeId = reader.readInt()
      ..isEdit = reader.readBool()
      ..picture = reader.readString();
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
    writer.writeBool(obj.productive ?? false);
    writer.writeString(obj.tax ?? '');
    writer.writeString(obj.cnic ?? '');
    writer.writeString(obj.myntn ?? '');
    writer.writeInt(obj.typeId ?? 0);
    writer.writeInt(obj.statusId ?? 0);
    writer.writeInt(obj.sectorId ?? 0);
    writer.writeBool(obj.isEdit ?? false);
    writer.writeString(obj.picture ?? "");
  }
}
