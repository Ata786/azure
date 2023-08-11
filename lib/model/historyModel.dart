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
