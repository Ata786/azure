import 'package:SalesUp/model/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/productsModel.dart';

class ShopServiceController extends GetxController{

  Rx<String> image = ''.obs;

  RxList<ProductsModel> productsList = <ProductsModel>[].obs;
  RxList<ProductsModel> filteredProductsList = <ProductsModel>[].obs;
  Rx<bool> checkProducts = false.obs;
  Rx<int> checkIn = 0.obs;

  List<OrderModel> orderList = [];
  Rx<int> quantity = 0.obs;
  Rx<int> radio = 0.obs;

  Rx<String> netRate = ''.obs;

}