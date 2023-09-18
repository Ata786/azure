
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../model/attendenceModel.dart';
import '../model/officeCodeModel.dart';
import '../model/userModel.dart';

class UserController extends GetxController{

  double latitude = 0.0;
  double longitude = 0.0;
  Rx<OfficeCodeModel>? officeCode;
  Rx<UserModel>? user;
  Rx<CheckIn> checkIn = CheckIn().obs;
  Rx<CheckOut> checkOut = CheckOut().obs;

  late StreamSubscription<ConnectivityResult> subscription;
  late ConnectivityResult connectivityResult;
  Rx<bool> isOnline = false.obs;

  void listenConnectivity()async{
    connectivityResult = await (Connectivity().checkConnectivity());
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile || result == ConnectivityResult.ethernet){
        isOnline.value = true;
      }else{
        isOnline.value = false;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenConnectivity();
  }


}