import 'package:hive/hive.dart';

class OrderModel {
  dynamic shopId;
  dynamic pjpNo;
  dynamic pjpDate;
  dynamic bookerId;
  dynamic invoiceStatus;
  dynamic userId;
  dynamic replace;
  dynamic reason;
  dynamic checkIn;
  dynamic image;
  dynamic orderNumber;
  dynamic weight;
  dynamic tonnage;
  OrderDataModel? orderDataModel;

  OrderModel(
      {this.shopId,
        this.pjpNo,
        this.pjpDate,
        this.bookerId,
        this.invoiceStatus,
        this.userId,
        this.replace,
        this.reason,
        this.checkIn,
        this.image,
      this.orderNumber,
        this.weight,
        this.tonnage,
      this.orderDataModel,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    shopId = json['shopId'];
    pjpNo = json['pjpNo'];
    pjpDate = json['pjpDate'];
    bookerId = json['bookerId'];
    invoiceStatus = json['invoiceStatus'];
    userId = json['userId'];
    replace = json['replace'];
    reason = json['reason'];
    checkIn = json['checkIn'];
    image = json['Image'];
    orderNumber = json['orderNumber'];
    weight = json['weight'];
    tonnage = json['tonnage'];
    if (json['orderDataModel'] != null) {
      orderDataModel = OrderDataModel.fromJson(json['orderDataModel']);
    } else {
      orderDataModel = OrderDataModel(); // Initialize with an empty OrderDataModel
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['shopId'] = this.shopId;
    data['pjpNo'] = this.pjpNo;
    data['pjpDate'] = this.pjpDate;
    data['bookerId'] = this.bookerId;
    data['invoiceStatus'] = this.invoiceStatus;
    data['userId'] = this.userId;
    data['replace'] = this.replace;
    data['reason'] = this.reason;
    data['checkIn'] = this.checkIn;
    data['Image'] = this.image;
    data['orderNumber'] = this.orderNumber;
    data['weight'] = this.weight;
    data['tonnage'] = this.tonnage;
    if (orderDataModel != null) {
      data['orderDataModel'] = orderDataModel!.toJson();
    }
    return data;
  }
}

class OrderDataModel {
  dynamic productId;
  dynamic rateId;
  dynamic netRate;
  dynamic quantity;
  dynamic fixedRate;

  OrderDataModel({this.fixedRate,this.productId, this.rateId, this.netRate, this.quantity});

  OrderDataModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    rateId = json['rateId'];
    netRate = json['netRate'];
    quantity = json['quantity'];
    fixedRate = json['fixedRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['rateId'] = this.rateId;
    data['netRate'] = this.netRate;
    data['quantity'] = this.quantity;
    data['fixedRate'] = this.fixedRate;
    return data;
  }
}


class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final typeId = 11;

  @override
  OrderModel read(BinaryReader reader) {
    return OrderModel(
      shopId: reader.read(),
      pjpNo: reader.read(),
      pjpDate: reader.read(),
      bookerId: reader.read(),
      invoiceStatus: reader.read(),
      userId: reader.read(),
      replace: reader.read(),
      reason: reader.read(),
      checkIn: reader.read(),
      image: reader.read(),
      orderNumber: reader.read(),
      weight: reader.read(),
      tonnage: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer.write(obj.shopId);
    writer.write(obj.pjpNo);
    writer.write(obj.pjpDate);
    writer.write(obj.bookerId);
    writer.write(obj.invoiceStatus);
    writer.write(obj.userId);
    writer.write(obj.replace);
    writer.write(obj.reason);
    writer.write(obj.checkIn);
    writer.write(obj.image);
    writer.write(obj.orderNumber);
    writer.write(obj.weight);
    writer.write(obj.tonnage);
  }
}

class OrderDataModelAdapter extends TypeAdapter<OrderDataModel> {
  @override
  final typeId = 12; // You need to choose a unique typeId for this class

  @override
  OrderDataModel read(BinaryReader reader) {
    return OrderDataModel(
      productId: reader.read(),
      rateId: reader.read(),
      netRate: reader.read(),
      quantity: reader.read(),
      fixedRate: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderDataModel obj) {
    writer.write(obj.productId);
    writer.write(obj.rateId);
    writer.write(obj.netRate);
    writer.write(obj.quantity);
    writer.write(obj.fixedRate);
  }
}




