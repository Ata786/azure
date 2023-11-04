import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/dashboardController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/data/postApi.dart';
import 'package:SalesUp/main.dart';
import 'package:SalesUp/model/attendenceModel.dart';
import 'package:SalesUp/model/creditModel.dart';
import 'package:SalesUp/model/userLiveModel.dart';
import 'package:SalesUp/utils/localNotification.dart';
import 'package:http/http.dart' as http;
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/model/userTrackingModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/utils/toast.dart';
import 'package:SalesUp/utils/widgets/dialoges.dart';
import 'package:SalesUp/view/attendanceReport.dart';
import 'package:SalesUp/view/dashboard/dashboardPage.dart';
import 'package:SalesUp/view/dashboard/traggingPage.dart';
import 'package:SalesUp/view/dashboard/visitPlanPage.dart';
import 'package:SalesUp/view/dayCloseStatus.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:SalesUp/view/dropSize.dart';
import 'package:SalesUp/view/receivableReport.dart';
import 'package:SalesUp/view/saleScreen.dart';
import 'package:SalesUp/view/targetReport.dart';
import 'package:SalesUp/view/userTracking.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../../controllers/shopServiceController.dart';
import '../../data/sharedPreference.dart';
import '../../model/orderCalculations.dart';
import '../../model/orderModel.dart';
import '../../res/images.dart';
import '../../utils/widgets/appWidgets.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pagesList = [Dashboard(), VisitPlan(), NewShop()];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 0;
  String attendanceTime = '';
  String director = "";

  @override
  void initState() {
    UserController userController = Get.find<UserController>();

    if(userController.user!.value.designation!.startsWith("Director")){
      director = "Director";
    }else{
      director = "";
    }



    Get.put(SyncNowController());
    Get.put(DashBoardController());
    Get.put(ShopServiceController());
    HiveDatabase.getData("syncDownList", "syncDown");
    HiveDatabase.getWeekPerformanceData("weekPerformance", "week");
    HiveDatabase.getMonthPerformanceData("monthPerformance", "month");
    HiveDatabase.getReasonData("reasonNo", "reason");
    HiveDatabase.getProducts("productsBox", "products");
    getAtten();
    getCalculation();
    super.initState();
  }

  void getCalculation()async{
    SyncNowController syncNowController = Get.find<SyncNowController>();
    OrderCalculationModel orderCalculate = await HiveDatabase.getOrderCalculation("orderCalculateBox", "orderCalculate");
    syncNowController.orderCalculationModel.value = orderCalculate;
  }

  void getAtten()async{
    UserController userController = Get.find<UserController>();
    CheckIn checkIn = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
    userController.checkIn.value = checkIn;
  }



  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    Get.put(SyncNowController());
    SyncNowController syncNowController = Get.find<SyncNowController>();
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Obx(() => textWidget(
          textColor: Colors.white,
          text: userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF"
              ? userController.page.value == 0 ? "Booker Performance" : userController.page.value == 1 ? "Visit Plan" : "New Shop"
              : "Sale Report",
          fontSize: FetchPixels.getPixelHeight(17),
          fontWeight: FontWeight.w600,
        )),
        elevation: 0,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Colors.white,
            )),
              actions: userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF" ? null
              : [
                InkWell(
                  onTap: (){
                    Get.to(DistributerScreen());
                  },
                    child: Icon(Icons.filter_alt_sharp,color: Colors.white,)),
                SizedBox(width: FetchPixels.getPixelWidth(20),),
              ],
      ),
      drawer: SizedBox(
        width: FetchPixels.width / 1.5,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: FetchPixels.getPixelHeight(150),
                child: DrawerHeader(
                  child: Row(
                    children: [
                      Image.asset(
                        man,
                        height: FetchPixels.getPixelHeight(60),
                        width: FetchPixels.getPixelWidth(60),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: FetchPixels.getPixelWidth(150),
                            child: textWidget(
                              textColor: Colors.black,
                              maxLines: 2,
                              text: userController.user != null ? userController.user!.value.fullName ?? "" : "",
                              fontSize: FetchPixels.getPixelHeight(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(5),),
                          Container(
                            width: FetchPixels.getPixelWidth(150),
                            child: textWidget(
                              maxLines: 2,
                              textColor: primaryColor,
                              text: userController.user != null ? userController.user!.value.email ?? "" : "",
                              fontSize: FetchPixels.getPixelHeight(13),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(5),),
                          textWidget(
                            textColor: primaryColor,
                            text: userController.user != null ? userController.user!.value.designation ?? "" : "",
                            fontSize: FetchPixels.getPixelHeight(13),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
             Obx(() =>  userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF"
                 ? Column(
               children: [
                 Obx(() => userController.user!.value.designation == "Admin" || userController.user!.value.designation == "NSM"
                 || userController.user!.value.designation == "Managing Director" || userController.user!.value.designation == "GM Sales"
                 || director == "Director"
             ? SizedBox()
                 : ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : ()async{
                     Get.toNamed(ATTENDANCE);
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   subtitle: textWidget(
                       text: userController.checkIn.value.attendanceDateTime ?? "00:00",
                        fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   title: textWidget(
                       text: "Attendance",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     attendance,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : (){
                     userController.page.value = 0;
                       _scaffoldKey.currentState!.closeDrawer();
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "Booker Performance",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     performance,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true ? (){} : (){
                     showSyncDownDialog(onTap: ()async{

                       Get.back();
                       if(userController.isOnline.value == false){

                         _scaffoldKey.currentState!.closeDrawer();
                         showToast(context, "Check Internet Service and try again");

                       }else{

                         var box1 = await Hive.openBox("syncDownList");
                         var box2 = await Hive.openBox("weekPerformance");
                         var box3 = await Hive.openBox("monthPerformance");
                         var box4 = await Hive.openBox("reasonNo");
                         var box5 = await Hive.openBox("productsBox");
                         var box6 = await Hive.openBox("reasonsName");
                         var box7 = await Hive.openBox("category");
                         var box8 = await Hive.openBox("product");
                         var box9 = await Hive.openBox("orderBox");
                         var box10 = await Hive.openBox("shopTypeBox");
                         var box11 = await Hive.openBox("shopSectorBox");
                         var box12 = await Hive.openBox("shopStatusBox");
                         var box13 = await Hive.openBox("orderCalculateBox");
                         box1.delete("syncDown");
                         box2.delete("week");
                         box3.delete("month");
                         box4.delete("reason");
                         box5.delete("products");
                         box6.delete("reason");
                         box7.delete("categoryName");
                         box8.delete("productRate");
                         box9.delete("order");
                         box10.delete("shopType");
                         box11.delete("shopSector");
                         box12.delete("shopStatus");
                         box13.delete("orderCalculate");
                         syncNowController.syncDownList.clear();
                         syncNowController.reasonModelList.clear();
                         syncNowController.filteredReasonList.clear();
                         syncNowController.nonProductiveList.clear();
                         syncNowController.searchList.clear();
                         syncNowController.orderCalculationModel.value = OrderCalculationModel();
                         allApis(_scaffoldKey.currentState);

                       }

                     });
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       textColor: Colors.black,
                       text: "Sync Down",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   subtitle: Obx(() => syncNowController.check.value == true ? Row(
                     children: [
                       SizedBox(
                         height: FetchPixels.getPixelHeight(10),
                         width: FetchPixels.getPixelWidth(10),
                         child: Center(child: CircularProgressIndicator(color: themeColor,strokeWidth: 2,),),
                       ),
                       SizedBox(width: FetchPixels.getPixelWidth(10),),
                       textWidget(
                           textColor: Colors.black,
                           text: "Wait for Sync Down Complete",
                           fontSize: FetchPixels.getPixelHeight(10),
                           fontWeight: FontWeight.w500)
                     ],
                   ) : SizedBox()),
                   leading: Image.asset(
                     color: Colors.black,
                     downArrow,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : (){
                     userController.page.value = 1;
                       _scaffoldKey.currentState!.closeDrawer();
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "Visit Plan",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     color: Colors.black,
                     visit,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : (){
                     userController.page.value = 2;
                       _scaffoldKey.currentState!.closeDrawer();
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "New Shops",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     building,
                     color: Colors.black,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.check.value == true ? (){} : (){
                     showSyncUpDialog(onTap: ()async{

                       if(userController.isOnline.value == true){

                         // List<NewShopModel> newShopList = await HiveDatabase.getNewShops("NewShopsBox", "NewShops");
                         //
                         // for(int i=0; i<newShopList.length; i++){
                         //   Map<String,dynamic> data = {
                         //     "ShopName": newShopList[i].shopName,
                         //     "ShopAddress": newShopList[i].shopAddress,
                         //     "OwnerPhone": newShopList[i].ownerPhone,
                         //     "OwnerName": newShopList[i].ownerName,
                         //     "OwnerCnic": newShopList[i].ownerCnic,
                         //     "Strm": newShopList[i].strn,
                         //     "Myntn": newShopList[i].myntn,
                         //     "Sector": newShopList[i].sectorSr,
                         //     "SaleTax": newShopList[i].salesTaxSr,
                         //     "ShopeType": newShopList[i].shopTypeSr,
                         //     "Gprs": newShopList[i].gprs,
                         //     "Image": newShopList[i].picture,
                         //     "DistributerId":  syncNowController.syncDownList[0].distributerId,
                         //     "UserId": userController.user!.value.id,
                         //   };
                         //   log('>>> ${data}');
                         //   addNewShop(data);
                         //
                         // }
                         //

                         HiveDatabase.getData("syncDownList", "syncDown");
                         List<SyncDownModel> editList = syncNowController.syncDownList.where((p0) => p0.isEdit == true).toList();

                         for(int i=0; i<editList.length; i++){
                           Map<String,dynamic> data = {
                             "Sr": editList[i].sr,
                             "Shopname": editList[i].shopname,
                             "Shopcode": editList[i].shopCode,
                             "Address": editList[i].address,
                             "Phone": editList[i].phone,
                             "Owner": editList[i].owner,
                             "Cnic": editList[i].cnic,
                             "Tax": editList[i].tax,
                             "Myntn": editList[i].myntn,
                             "SectorId": editList[i].sectorId,
                             "StatusId": editList[i].statusId,
                             "TypeId": editList[i].typeId,
                             "Gprs": editList[i].gprs,
                             "Image": editList[i].picture,
                           };

                           editShopApi(data);

                         }

                         List<CreditModel> creditList = await HiveDatabase.getCreditList("creditBox", "credit");
                         List<CreditModel> credits = creditList.where((element) => element.recovery != 0.0).toList();
                         for(int i=0; i<credits.length; i++){
                           DateTime d = DateTime.now();
                           String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(d.toUtc());
                           Map<String,dynamic> data = {
                             "billNoId": credits[i].billNoId,
                             "realisedAmount": credits[i].recovery,
                             "currentDistId": credits[i].currentDistId,
                             "bookerId": credits[i].bookerId,
                             "shopId": credits[i].shopId,
                             "date": formattedDate
                           };
                           mobileRecovery(data);
                         }


                         DateTime currentDateTime = DateTime.now();

                         // Set the time portion to "00:00:00.000"
                         DateTime modifiedDateTime = DateTime(
                           currentDateTime.year,
                           currentDateTime.month,
                           currentDateTime.day,
                           0,  // Hour
                           0,  // Minute
                           0,  // Second
                           0,  // Millisecond
                         );

                         Map<String,dynamic> data = {
                           "BookerId": userController.user!.value.id,
                           "CreatedOn": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(modifiedDateTime)
                         };

                         mobileSyncDeleteApi(data);


                         _scaffoldKey.currentState!.closeDrawer();
                         Get.back();
                       }else{
                         Get.back();
                         _scaffoldKey.currentState!.closeDrawer();
                         showToast(context, "Check Internet Service and try again");
                       }

                     });
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "Sync Up",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   subtitle: Obx(() => syncNowController.checkSyncUp.value == true ? Row(
                     children: [
                       SizedBox(
                         height: FetchPixels.getPixelHeight(10),
                         width: FetchPixels.getPixelWidth(10),
                         child: Center(child: CircularProgressIndicator(color: themeColor,strokeWidth: 2,),),
                       ),
                       SizedBox(width: FetchPixels.getPixelWidth(10),),
                       textWidget(
                           textColor: Colors.black,
                           text: "Wait for Sync Up Complete",
                           fontSize: FetchPixels.getPixelHeight(10),
                           fontWeight: FontWeight.w500)
                     ],
                   ) : SizedBox()),
                   leading: Image.asset(
                     upArrow,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : (){
                     Get.toNamed(CREDIT_LIST);
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "Credit List",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     creditList,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : ()async{


                       if(userController.isOnline.value == true){

                         if(userController.checkOut.value.outAttendanceDateTime == '' || userController.checkOut.value.outAttendanceDateTime == null){
                           ScaffoldMessenger.of(Get.context!)
                               .showSnackBar(SnackBar(content: Text("Please Checkout before Log Out")));
                         }else{

                           CheckOut check = await HiveDatabase.getCheckOutAttendance("checkOutAttendance", "checkOut");
                           CheckIn checkIn = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
                           RemarksModel remarksModel = await HiveDatabase.getRemarks("remarksBox", 'remarks');

                           DateFormat inputFormat = DateFormat("dd MMM y hh:mm a");

                           DateTime dateTime = inputFormat.parse(check.outAttendanceDateTime!);
                           String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime);

                           DateTime checkInDateTime = inputFormat.parse(checkIn.attendanceDateTime!);
                           String checkInFormattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(checkInDateTime);

                           Map<String,dynamic> checkOut = {
                             "id": checkIn.id,
                             "userId": userController.user!.value.id,
                             "latitude": checkIn.latitude,
                             "longitude": checkIn.longitude,
                             "attendanceDateTime": checkInFormattedDateTime,
                             "outLongitude": check.outLongitude,
                             "outLatitude": check.outLatitude,
                             "outAttendanceDateTime": formattedDateTime,
                             "checkIn": remarksModel.checkIn ?? "0.5",
                             "remarks": remarksModel.remarks ?? "",
                           };

                           log('>>>> ${checkOut}');

                           await syncNowController.updateAttendance(checkOut);


                         }

                       }else{
                         _scaffoldKey.currentState!.closeDrawer();
                         showToast(context, "");
                       }

                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "Logout",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     logout,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 SizedBox(height: FetchPixels.getPixelHeight(30),),
                 Center(
                   child: textWidget(
                     textColor: themeColor,
                     text: "SalesUp",
                     fontSize: FetchPixels.getPixelHeight(15),
                     fontWeight: FontWeight.bold,),
                 ),
                 SizedBox(height: FetchPixels.getPixelHeight(20),),
               ],
             )
                 : Column(
               children: [
                 Obx(() => userController.user!.value.designation == "Admin" || userController.user!.value.designation == "NSM"
                     || userController.user!.value.designation == "Managing Director" || userController.user!.value.designation == "GM Sales"
                     || director == "Director"
                     ? SizedBox()
                     : ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : ()async{
                     Get.toNamed(ATTENDANCE);
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   subtitle: textWidget(
                       text:      userController.checkIn.value.attendanceDateTime ?? "      00:00",
                       // text: userController.user!.value.attendance == "" ? "" : changeDateFormat(userController.user!.value.attendance),
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   title: textWidget(
                       text: "      Attendance",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     attendance,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 )),
                 ListTile(
                   onTap:()async{
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "     Sale Report",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     sale,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 ),
                 ListTile(
                   onTap:()async{
                    Get.to(DropSizeScreen());
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "   LPPC Report",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     dropSize,
                     height: FetchPixels.getPixelHeight(30),
                     width: FetchPixels.getPixelWidth(30),
                   ),
                 ),
                 userController.user!.value.designation == "Admin" || userController.user!.value.designation == "NSM"
                     || userController.user!.value.designation == "Managing Director" || userController.user!.value.designation == "GM Sales"
                     || director == "Director"
                 ? ListTile(
                   onTap:()async{
                     Get.to(AttendanceReportScreen());
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "Attendance Report",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     attReport,
                     height: FetchPixels.getPixelHeight(40),
                     width: FetchPixels.getPixelWidth(40),
                   ),
                 ) : SizedBox(),
                 userController.user!.value.designation == "Admin" || userController.user!.value.designation == "NSM"
                     || userController.user!.value.designation == "Managing Director" || userController.user!.value.designation == "GM Sales"
                     || director == "Director"
                     ? ListTile(
                   onTap:()async{
                     List<UserTrackingModel> userTrackingList1 = [];
                     List<UserTrackingModel> userTrackingList2 = [];
                     userTrackingList1.clear();
                     userTrackingList2.clear();
                     List<UserTrackingModel> userTrackingList =  await userTrackingApis();
                     userTrackingList1.addAll(userTrackingList);
                     Get.to(UserTrackingScreen(userTrackingList1));
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "User Tracking",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     attReport,
                     height: FetchPixels.getPixelHeight(40),
                     width: FetchPixels.getPixelWidth(40),
                   ),
                 ) : SizedBox(),
                 ListTile(
                   onTap:()async{
                     Get.to(TargetReport());
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "    Target Report",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     target,
                     height: FetchPixels.getPixelHeight(25),
                     width: FetchPixels.getPixelWidth(25),
                   ),
                 ),
                 ListTile(
                   onTap:()async{
                     Get.to(ReceivableReport());
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "   Receivable Report",
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500,
                       textColor: Colors.black),
                   leading: Image.asset(
                     color: Colors.black,
                     creditList,
                     height: FetchPixels.getPixelHeight(25),
                     width: FetchPixels.getPixelWidth(25),
                   ),
                 ),
                 Obx(() => ListTile(
                   onTap: syncNowController.checkSyncUp.value == true || syncNowController.check.value == true ? (){} : (){
                     Get.to(DayCloseStatusScreen());
                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: " Day Close Status",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     dayclose,
                     height: FetchPixels.getPixelHeight(35),
                     width: FetchPixels.getPixelWidth(35),
                   ),
                 )),
                 ListTile(
                   onTap: ()async{

                     if(userController.user!.value.designation == "Admin" || userController.user!.value.designation == "NSM"
                         || userController.user!.value.designation == "Managing Director" || userController.user!.value.designation == "GM Sales"
                         || director == "Director"){

                       Get.dialog(
                           AlertDialog(content: Container(
                             height: FetchPixels.getPixelHeight(100),
                             width: FetchPixels.width,
                             color: Colors.white,
                             child: Column(
                               children: [
                                 textWidget(text: "Are your sure?\nYou want to logout?", fontSize: FetchPixels.getPixelHeight(20), fontWeight: FontWeight.w500,textAlign: TextAlign.center),
                                 SizedBox(height: FetchPixels.getPixelHeight(25),),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     InkWell(
                                         onTap: (){
                                           Get.back();
                                         },
                                         child: textWidget(text: "No", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.red)),
                                     InkWell(
                                         onTap: ()async{
                                           SharedPreferences shared = await SharedPreferences.getInstance();
                                           bool remove = await shared.remove("user");
                                           if(remove == true){
                                             Get.offAllNamed(SIGN_IN_SCREEN);
                                           }
                                         },
                                         child: textWidget(text: "Yes", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.green)),
                                   ],
                                 ),
                               ],
                             ),
                           ),)
                       );

                     }else{

                       if(userController.isOnline.value == false){
                         _scaffoldKey.currentState!.closeDrawer();
                         showToast(context, "");
                       }else{

                         if(userController.checkOut.value.outAttendanceDateTime == '' || userController.checkOut.value.outAttendanceDateTime == null){
                           ScaffoldMessenger.of(Get.context!)
                               .showSnackBar(SnackBar(behavior: SnackBarBehavior.floating,content: Text("Please Checkout before Log Out")));
                         }else{

                           Get.dialog(
                               AlertDialog(content: Container(
                                 height: FetchPixels.getPixelHeight(100),
                                 width: FetchPixels.width,
                                 color: Colors.white,
                                 child: Column(
                                   children: [
                                     textWidget(text: "Are your sure?\nYou want to logout?",
                                         fontSize: FetchPixels.getPixelHeight(20),
                                         fontWeight: FontWeight.w500,
                                         textAlign: TextAlign.center),
                                     SizedBox(height: FetchPixels.getPixelHeight(25),),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         InkWell(
                                             onTap: () {
                                               Get.back();
                                             },
                                             child: textWidget(text: "No", fontSize: FetchPixels
                                                 .getPixelHeight(15), fontWeight: FontWeight
                                                 .w600, textColor: Colors.red)),
                                         InkWell(
                                             onTap: () async {
                                               SharedPreferences shared = await SharedPreferences
                                                   .getInstance();
                                               bool remove = await shared.remove("user");
                                               if (remove == true) {
                                                 Get.offAllNamed(SIGN_IN_SCREEN);
                                               }
                                             },
                                             child: textWidget(text: "Yes", fontSize: FetchPixels
                                                 .getPixelHeight(15), fontWeight: FontWeight
                                                 .w600, textColor: Colors.green)),
                                       ],
                                     )
                                   ],
                                 ),
                               ),)
                           );

                         }

                       }


                     }

                   },
                   minLeadingWidth: FetchPixels.getPixelWidth(20),
                   title: textWidget(
                       text: "     Logout",
                       textColor: Colors.black,
                       fontSize: FetchPixels.getPixelHeight(17),
                       fontWeight: FontWeight.w500),
                   leading: Image.asset(
                     logout,
                     height: FetchPixels.getPixelHeight(20),
                     width: FetchPixels.getPixelWidth(20),
                   ),
                 ),
                 SizedBox(height: FetchPixels.getPixelHeight(80),),
                 Center(
                   child: textWidget(
                     textColor: themeColor,
                     text: "SalesUp",
                     fontSize: FetchPixels.getPixelHeight(15),
                     fontWeight: FontWeight.bold,),
                 ),
               ],
             )),
            ],
          ),
        ),
      ),
      body: Obx(() => userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF"
          ? pagesList[userController.page.value] : SaleScreen(),
         ),
            bottomNavigationBar: userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF" ? BottomNavigationBar(
              currentIndex: userController.page.value,
              onTap: (index) {
                userController.page.value = index;
              },
              selectedFontSize: FetchPixels.getPixelHeight(15),
              items: [
                BottomNavigationBarItem(
                    icon: Obx(() => Image.asset(performance,
                        color: userController.page.value == 0 ? themeColor : Color(0xffE0E0E0),
                        height: FetchPixels.getPixelHeight(userController.page.value  == 0 ? 45 : 35),
                        width: FetchPixels.getPixelWidth(userController.page.value  == 0 ? 45 : 35))),
                    label: "Performance"),
                BottomNavigationBarItem(
                    icon: Obx(() => Image.asset(visit,
                        color: userController.page.value == 1 ? themeColor : null,
                        height: FetchPixels.getPixelHeight(userController.page.value == 1 ? 45 : 35),
                        width: FetchPixels.getPixelWidth(userController.page.value == 1 ? 45 : 35))),
                    label: "Visit Plan"),
                BottomNavigationBarItem(
                    icon: Obx(() => Image.asset(building,
                        color: userController.page.value == 2 ? themeColor : null,
                        height: FetchPixels.getPixelHeight(userController.page.value == 2 ? 45 : 35),
                        width: FetchPixels.getPixelWidth(userController.page.value == 2 ? 45 : 35))),
                    label: "New Shop"),
              ],
            ) : null,
    ));
  }

  String formatDateAndTime(String dateAndTime) {
    DateTime dateTime = DateTime.parse(dateAndTime);
    String formattedTime = dateTime.toUtc().toIso8601String();
    return formattedTime;
  }


  Future<List<UserTrackingModel>> userTrackingApis()async{

    List<UserTrackingModel> userTracking = [];

    try{

      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

      var res = await http.post(Uri.parse('$BASE_URL/User/UserList'),headers: {
        'Content-Type': 'application/json',
      },body: jsonEncode(["ASM","RSM"]));

      Get.back();

      if(res.statusCode ==  200){


        List<dynamic> json = jsonDecode(res.body);
        userTracking = json.map((e) => UserTrackingModel.fromJson(e)).toList();

      }else{
        log('>>>> Error ${res.body}');
      }


    }catch(e){
      log('>>>> exception ${e.toString()}');
    }
    return userTracking;
  }


}
