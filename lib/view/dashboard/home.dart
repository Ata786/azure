import 'dart:async';
import 'dart:convert';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/dashboardController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/utils/widgets/dialoges.dart';
import 'package:SalesUp/view/dashboard/dashboardPage.dart';
import 'package:SalesUp/view/dashboard/traggingPage.dart';
import 'package:SalesUp/view/dashboard/visitPlanPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/shopServiceController.dart';
import '../../data/postApis.dart';
import '../../model/orderCalculations.dart';
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

  @override
  void initState() {
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
    var box = await Hive.openBox("attendance");
    String attendance = box.get('markAttendance');
    setState(() {
      if(attendance.isNotEmpty){
        DateTime date = DateTime.parse(attendance);
        attendanceTime = DateFormat('dd MMM yyyy hh:mm a').format(date);
      }else{
        attendanceTime = attendance;
      }
    });
  }



  Future<void> markAttendance() async {
    UserController userController = Get.find<UserController>();
    final url = Uri.parse('http://125.209.79.107:7700/api/Attendance');

    final response = await http.post(
      url,
      body: jsonEncode({"userId": userController.user!.value.id,"latitude": userController.latitude,"longitude": userController.longitude}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Your Attendance is Successfully marked",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: themeColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          msg: "Your Attendance is Already Marked",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: themeColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  Future<String> getAttendanceData() async {
    UserController userController = Get.find<UserController>();
    final url =
    Uri.parse('http://125.209.79.107:7700/api/Attendance/${userController.user!.value.id}');
    String formattedDate = '';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      String attendance = jsonData['attendanceDateTime'];
      setState(() {
        DateTime date = DateTime.parse(attendance);
        formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(date);

      });
    } else {
      throw Exception(
          'Failed to fetch attendance data. Error:${response.body}');
    }

    return formattedDate;
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
        title: textWidget(
          textColor: Colors.white,
          text: page == 0 ? "Booker Performance" : page == 1 ? "Visit Plan" : "New Shop",
          fontSize: FetchPixels.getPixelHeight(17),
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Colors.white,
            )),
      ),
      drawer: SizedBox(
        width: FetchPixels.width / 1.5,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
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
            Obx(() => ListTile(
              onTap: syncNowController.check.value == true ? (){} : ()async{
                var box = await Hive.openBox("attendance");
                String attendance = box.get('markAttendance');

                if(attendance == '' || attendance.isEmpty){
                  await markAttendance();
                  String att = await getAttendanceData();
                  box.put("markAttendance", att);
                  String attendance2 = box.get('markAttendance');
                  setState(() {
                    attendanceTime = attendance2;
                  });
                }else{
                  setState(() {
                    attendanceTime = attendance;
                  });
                }

              },
              minLeadingWidth: FetchPixels.getPixelWidth(20),
              subtitle: textWidget(
                  text: attendanceTime,
                  // text: userController.user!.value.attendance == "" ? "" : changeDateFormat(userController.user!.value.attendance),
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
                onTap: syncNowController.check.value == true ? (){} : (){
                  setState(() {
                    page = 0;
                    _scaffoldKey.currentState!.closeDrawer();
                  });
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
              ListTile(
                onTap: (){
                  showSyncDownDialog(onTap: ()async{
                    Get.back();
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
                    // syncDownApi(context);
                    // await getWeekPerformance(context: context);
                    // getMonthlyPerformance(context: context);
                    // getProducts(context: context);
                    // getReasons(context);
                    // getCategoryName(context);
                    // getRateDetails(context);
                    // await getShopTexData(context);
                    allApis();
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
              ),
              Obx(() => ListTile(
                onTap: syncNowController.check.value == true ? (){} : (){
                  setState(() {
                    page = 1;
                    _scaffoldKey.currentState!.closeDrawer();
                  });
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
                onTap: syncNowController.check.value == true ? (){} : (){
                  setState(() {
                    page = 2;
                    _scaffoldKey.currentState!.closeDrawer();
                  });
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
                  HiveDatabase.getReasonData("reasonNo", "reason");
                },
                minLeadingWidth: FetchPixels.getPixelWidth(20),
                title: textWidget(
                    text: "Sync Up",
                    textColor: Colors.black,
                    fontSize: FetchPixels.getPixelHeight(17),
                    fontWeight: FontWeight.w500),
                leading: Image.asset(
                  upArrow,
                  height: FetchPixels.getPixelHeight(20),
                  width: FetchPixels.getPixelWidth(20),
                ),
              )),
              Obx(() => ListTile(
                onTap: syncNowController.check.value == true ? (){} : (){
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
                onTap: syncNowController.check.value == true ? (){} : ()async{
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
                            )
                          ],
                        ),
                      ),)
                  );
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
              SizedBox(height: FetchPixels.getPixelHeight(50),),
              Center(
                child: textWidget(
                  textColor: themeColor,
                  text: "SalesUp",
                  fontSize: FetchPixels.getPixelHeight(15),
                  fontWeight: FontWeight.bold,),
              ),
            ],
          ),
        ),
      ),
      body: pagesList[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        selectedFontSize: FetchPixels.getPixelHeight(15),
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(performance,
                  color: page == 0 ? themeColor : null,
                  height: FetchPixels.getPixelHeight(page == 0 ? 45 : 35),
                  width: FetchPixels.getPixelWidth(page == 0 ? 45 : 35)),
              label: "Performance"),
          BottomNavigationBarItem(
              icon: Image.asset(visit,
                  color: page == 1 ? themeColor : null,
                  height: FetchPixels.getPixelHeight(page == 1 ? 45 : 35),
                  width: FetchPixels.getPixelWidth(page == 1 ? 45 : 35)),
              label: "Visit Plan"),
          BottomNavigationBarItem(
              icon: Image.asset(building,
                  color: page == 2 ? themeColor : null,
                  height: FetchPixels.getPixelHeight(page == 2 ? 45 : 35),
                  width: FetchPixels.getPixelWidth(page == 2 ? 45 : 35)),
              label: "New Shop"),
        ],
      ),
    ));
  }



  
}
