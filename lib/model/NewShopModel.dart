import 'package:hive/hive.dart';

class NewShopModel {
  int? sr;
  int? shopCode;
  String? shopName;
  String? shopAddress;
  String? ownerPhone;
  String? ownerName;
  String? ownerCnic;
  String? strn;
  String? myntn;
  String? salesTax;
  String? sector;
  String? shopType;
  String? picture;
  String? gprs;

  NewShopModel(
      {this.sr,
        this.shopCode,
        this.shopName,
        this.shopAddress,
        this.ownerPhone,
        this.ownerName,
        this.ownerCnic,
        this.strn,
        this.myntn,
        this.salesTax,
        this.sector,
        this.shopType,
        this.picture,
        this.gprs});

  NewShopModel.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    shopCode = json['shopCode'];
    shopName = json['shopName'];
    shopAddress = json['shopAddress'];
    ownerPhone = json['ownerPhone'];
    ownerName = json['ownerName'];
    ownerCnic = json['ownerCnic'];
    strn = json['strn'];
    myntn = json['myntn'];
    salesTax = json['salesTax'];
    sector = json['sector'];
    shopType = json['shopType'];
    picture = json['picture'];
    gprs = json['gprs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['shopCode'] = this.shopCode;
    data['shopName'] = this.shopName;
    data['shopAddress'] = this.shopAddress;
    data['ownerPhone'] = this.ownerPhone;
    data['ownerName'] = this.ownerName;
    data['ownerCnic'] = this.ownerCnic;
    data['strn'] = this.strn;
    data['myntn'] = this.myntn;
    data['salesTax'] = this.salesTax;
    data['sector'] = this.sector;
    data['shopType'] = this.shopType;
    data['picture'] = this.picture;
    data['gprs'] = this.gprs;
    return data;
  }
}


class NewShopModelHiveAdapter extends TypeAdapter<NewShopModel> {

  @override
  final int typeId = 16;// Replace with a unique type ID for your model

  @override
  NewShopModel read(BinaryReader reader) {
    final newShop = NewShopModel();
    newShop.sr = reader.readInt();
    newShop.shopCode = reader.readInt();
    newShop.shopName = reader.readString();
    newShop.shopAddress = reader.readString();
    newShop.ownerPhone = reader.readString();
    newShop.ownerName = reader.readString();
    newShop.ownerCnic = reader.readString();
    newShop.strn = reader.readString();
    newShop.myntn = reader.readString();
    newShop.salesTax = reader.readString();
    newShop.sector = reader.readString();
    newShop.shopType = reader.readString();
    newShop.picture = reader.readString();
    newShop.gprs = reader.readString();
    return newShop;
  }

  @override
  void write(BinaryWriter writer, NewShopModel newShop) {
    writer.writeInt(newShop.sr ?? 0);
    writer.writeInt(newShop.shopCode ?? 0);
    writer.writeString(newShop.shopName ?? '');
    writer.writeString(newShop.shopAddress ?? '');
    writer.writeString(newShop.ownerPhone ?? '');
    writer.writeString(newShop.ownerName ?? '');
    writer.writeString(newShop.ownerCnic ?? '');
    writer.writeString(newShop.strn ?? '');
    writer.writeString(newShop.myntn ?? '');
    writer.writeString(newShop.salesTax ?? '');
    writer.writeString(newShop.sector ?? '');
    writer.writeString(newShop.shopType ?? '');
    writer.writeString(newShop.picture ?? '');
    writer.writeString(newShop.gprs ?? '');
  }
}