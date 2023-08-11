import 'package:azure/utils/routes/routePath.dart';
import 'package:azure/view/NewShops.dart';
import 'package:azure/view/Splash.dart';
import 'package:azure/view/dashboard/home.dart';
import 'package:azure/view/history.dart';
import 'package:azure/view/officeCode.dart';
import 'package:azure/view/orderDetail.dart';
import 'package:azure/view/shopService.dart';
import 'package:azure/view/signin.dart';
import 'package:azure/view/store.dart';
import 'package:get/get.dart';

import '../../view/creditList.dart';

class Routes{

  static List<GetPage> routesLIst = [
    GetPage(name: SPLASH, page: ()=> Splash()),
    GetPage(name: OFFICE_CODE_SCREEN, page: ()=> OfficeCode()),
    GetPage(name: SIGN_IN_SCREEN, page: ()=> SignIn()),
    GetPage(name: HOME, page: ()=> Home()),
    GetPage(name: SHOP_SERVICE, page: ()=> ShopService()),
    GetPage(name: STORE, page: ()=> StoreScreen()),
    GetPage(name: SHOP_HISTORY, page: ()=> ShopHistory()),
    GetPage(name: NEW_SHOPS, page: ()=> NewShops()),
    GetPage(name: ORDER_DETAIL, page: ()=> OrderDetail()),
    GetPage(name: CREDIT_LIST, page: ()=> CreditList()),
  ];

}