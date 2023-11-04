class AddProductsModel {
  int? serial;
  String? product;
  String? stock;

  AddProductsModel({this.serial, this.product, this.stock});

  AddProductsModel.fromJson(Map<String, dynamic> json) {
    serial = json['serial'];
    product = json['product'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serial'] = this.serial;
    data['product'] = this.product;
    data['stock'] = this.stock;
    return data;
  }
}