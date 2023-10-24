import 'dart:convert';
import 'dart:developer';

import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/distributionModel.dart';
import 'package:SalesUp/model/financialYearModel.dart';
import 'package:SalesUp/model/lppcModel.dart';
import 'package:SalesUp/model/receivableInvoicesModel.dart';
import 'package:SalesUp/model/receivableModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/view/receivableReport.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DistributionController extends GetxController{

  RxList<DistributionModel> distributionList = <DistributionModel>[].obs;
  RxList<FinancialYearModel> financialYearList = <FinancialYearModel>[].obs;
  List<int> distributorIdList = [];
  List<DistributionModel> selectedItems = [];



  Future<DaysModel> saleReportApis(Map<String,dynamic> body)async{
    DaysModel daysModel = DaysModel();
    try{

      var res = await http.post(Uri.parse("${BASE_URL}/SaleReport"),headers: {'Content-Type': 'application/json'},body: jsonEncode(body));
      log('Response is ${res.body}');
      if(res.statusCode == 200){

         Map<String,dynamic> data = jsonDecode(res.body);
         daysModel = DaysModel.fromJson(data);

      }else{
        log('Error is ${res.body}');
      }

    }catch(e){
      log('Exception ${e.toString()}');
    }
    return daysModel;
  }



  Future<SaleDistributionModel> saleReportByDayApis(Map<String,dynamic> body)async{
    SaleDistributionModel saleDistributionModel = SaleDistributionModel();
    log('>>>> ${body}');
    // try{

      var res = await http.post(Uri.parse("${BASE_URL}/SaleReport/SaleReportByGivenDate"),headers: {'Content-Type': 'application/json'},body: jsonEncode(body));
      log('>>>> ${res.statusCode}');
      if(res.statusCode == 200){

        Map<String,dynamic> data = jsonDecode(res.body);
        saleDistributionModel = SaleDistributionModel.fromJson(data);

      }else{
        log('Error is ${res.body}');
      }

    // }catch(e){
    //   log('Exception ${e.toString()}');
    // }
    return saleDistributionModel;
  }




  Future<ReceivableModel> receivableReportApis(Map<String,dynamic> body)async{
    ReceivableModel receivableModel = ReceivableModel();
    try{

      var res = await http.post(Uri.parse("${BASE_URL}/ReceivableReport"),headers: {'Content-Type': 'application/json'},body: jsonEncode(body));
      log('Response is ${res.body}');
      if(res.statusCode == 200){

        Map<String,dynamic> data = jsonDecode(res.body);
        receivableModel = ReceivableModel.fromJson(data);

      }else{
        log('Error is ${res.body}');
      }

    }catch(e){
      log('Exception ${e.toString()}');
    }
    return receivableModel;
  }





  Future<ReceivableInvoicesModel> receivableInvoicesApis(Map<String,dynamic> body)async{
    ReceivableInvoicesModel receivableInvoicesModel = ReceivableInvoicesModel();
    try{

      var res = await http.post(Uri.parse("${BASE_URL}/RRInvoices"),headers: {'Content-Type': 'application/json'},body: jsonEncode(body));
      if(res.statusCode == 200){

        Map<String,dynamic> data = jsonDecode(res.body);
        receivableInvoicesModel = ReceivableInvoicesModel.fromJson(data);

      }else{
        log('Error is ${res.body}');
      }

    }catch(e){
      log('Exception ${e.toString()}');
    }
    return receivableInvoicesModel;
  }





  Future<LppcModel> lppcListApi(Map<String,dynamic> body)async{
    LppcModel lppc = LppcModel();
    try{

      var res = await http.post(Uri.parse("${BASE_URL}/LPPC"),headers: {'Content-Type': 'application/json'},body: jsonEncode(body));
      if(res.statusCode == 200){

        log('>>>> ${res.body}');

        Map<String,dynamic> data = jsonDecode(res.body);
        lppc = LppcModel.fromJson(data);

      }else{
        log('Error is ${res.body}');
      }

    }catch(e){
      log('Exception ${e.toString()}');
    }
    return lppc;
  }




  Future<List<BookerList>> lppcApi(Map<String,dynamic> body)async{
    List<BookerList> bookerList = [];
    try{

      var res = await http.post(Uri.parse("${BASE_URL}/LPPCReportList"),headers: {'Content-Type': 'application/json'},body: jsonEncode(body));
     log('>>> ${res.statusCode} and ${res.body}');
      if(res.statusCode == 200){

        List<dynamic> data = jsonDecode(res.body);
        bookerList = data.map((e) => BookerList.fromJson(e)).toList();

      }else{
        log('Error is ${res.body}');
      }

    }catch(e){
      log('Exception ${e.toString()}');
    }
    return bookerList;
  }




  String formatNumberWithCommas(String decimalString) {
    NumberFormat formatter = NumberFormat("#,###.####");
    return formatter.format(double.parse(decimalString));
  }

}