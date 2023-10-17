class ReceivableInvoicesModel {
  List<ReciveableInvoices>? reciveableInvoices;
  List<RecoveryInvoices>? recoveryInvoices;
  ReceivableInvoicesModel({
    this.reciveableInvoices,
    this.recoveryInvoices,
  });

  ReceivableInvoicesModel.fromJson(Map<String, dynamic> json){
    if(json['reciveableInvoices'] != null){
      reciveableInvoices = List.from(json['reciveableInvoices']).map((e)=>ReciveableInvoices.fromJson(e)).toList();
    }
    if(json['recoveryInvoices'] != null){
      recoveryInvoices = List.from(json['recoveryInvoices']).map((e)=>RecoveryInvoices.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if(reciveableInvoices != null){
      _data['reciveableInvoices'] = reciveableInvoices!.map((e)=>e.toJson()).toList();
    }
    if(recoveryInvoices != null){
      _data['recoveryInvoices'] = recoveryInvoices!.map((e)=>e.toJson()).toList();
    }
    return _data;
  }
}

class ReciveableInvoices {
  ReciveableInvoices({
    required this.distributorId,
    required this.distributorName,
    required this.invoices,
  });
  late final int distributorId;
  late final String distributorName;
  late final List<Invoices> invoices;

  ReciveableInvoices.fromJson(Map<String, dynamic> json){
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    invoices = List.from(json['invoices']).map((e)=>Invoices.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['distributorId'] = distributorId;
    _data['distributorName'] = distributorName;
    _data['invoices'] = invoices.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Invoices {
  Invoices({
    this.reciveableDate,
    this.shopName,
    this.reciveableAmount,
    this.recoverAmount,
    this.shopId,
    this.billNoId,
    this.recoveryDate,
    this.recoveredAmount,
  });
  String? reciveableDate;
  String? shopName;
  double? reciveableAmount;
  dynamic recoverAmount;
  int? shopId;
  int? billNoId;
  String? recoveryDate;
  double? recoveredAmount;

  Invoices.fromJson(Map<String, dynamic> json){
    reciveableDate = json['reciveableDate'] ?? "";
    shopName = json['shopName'] ?? "";
    reciveableAmount = json['reciveableAmount'] ?? 0.0;
    recoverAmount = json['recoverAmount'];
    shopId = json['shopId'] ?? 0;
    billNoId = json['billNoId'] ?? 0;
    recoveryDate = json['recoveryDate'] ?? "";
    recoveredAmount = json['recoveredAmount'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['reciveableDate'] = reciveableDate;
    _data['shopName'] = shopName;
    _data['reciveableAmount'] = reciveableAmount;
    _data['recoverAmount'] = recoverAmount;
    _data['shopId'] = shopId;
    _data['billNoId'] = billNoId;
    _data['recoveryDate'] = recoveryDate;
    _data['recoveredAmount'] = recoveredAmount;
    return _data;
  }
}

class RecoveryInvoices {
  RecoveryInvoices({
    required this.distributorId,
    required this.distributorName,
    required this.invoices,
  });
  late final int distributorId;
  late final String distributorName;
  late final List<Invoices> invoices;

  RecoveryInvoices.fromJson(Map<String, dynamic> json){
    distributorId = json['distributorId'];
    distributorName = json['distributorName'];
    invoices = List.from(json['invoices']).map((e)=>Invoices.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['distributorId'] = distributorId;
    _data['distributorName'] = distributorName;
    _data['invoices'] = invoices.map((e)=>e.toJson()).toList();
    return _data;
  }
}