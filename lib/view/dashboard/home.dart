import 'package:azure/controllers/UserController.dart';
import 'package:azure/controllers/dashboardController.dart';
import 'package:azure/controllers/syncNowController.dart';
import 'package:azure/data/getApis.dart';
import 'package:azure/data/hiveDb.dart';
import 'package:azure/model/reasonsModel.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:azure/utils/routes/routePath.dart';
import 'package:azure/utils/widgets/dialoges.dart';
import 'package:azure/view/dashboard/dashboardPage.dart';
import 'package:azure/view/dashboard/traggingPage.dart';
import 'package:azure/view/dashboard/visitPlanPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/shopServiceController.dart';
import '../../data/postApis.dart';
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

    super.initState();
  }

  // void checkAttendance(){
  //   UserController userController = Get.find<UserController>();
  //   print('>>> ${userController.user!.value.id!}');
  //   setAttendence(userId:  userController.user!.value.id!,latitude: userController.latitude,longitude: userController.longitude,);
  // }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    Get.put(SyncNowController());
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
            ListTile(
              minLeadingWidth: FetchPixels.getPixelWidth(20),
                subtitle: textWidget(
                    text: userController.user!.value.attendance == "" ? "" : changeDateFormat(userController.user!.value.attendance),
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
              ),
              ListTile(
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
              ),
              ListTile(
                onTap: (){
                  showSyncDownDialog(onTap: ()async{
                    Get.back();
                    syncDownApi(context,_scaffoldKey.currentState);
                    await getWeekPerformance(context: context);
                    getMonthlyPerformance(context: context);
                    getProducts(context: context);
                    getReasons(context);
                    getCategoryName(context);
                    await getRateDetails(context);
                  });
                },
                minLeadingWidth: FetchPixels.getPixelWidth(20),
                title: textWidget(
                    textColor: Colors.black,
                    text: "Sync Down",
                    fontSize: FetchPixels.getPixelHeight(17),
                    fontWeight: FontWeight.w500),
                leading: Image.asset(
                  color: Colors.black,
                  downArrow,
                  height: FetchPixels.getPixelHeight(20),
                  width: FetchPixels.getPixelWidth(20),
                ),
              ),
              ListTile(
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
              ),
              ListTile(
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
              ),
              ListTile(
                onTap: (){
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
              ),
              ListTile(
                onTap: (){
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
              ),
              ListTile(
                onTap: ()async{
                  SharedPreferences shared = await SharedPreferences.getInstance();
                  bool remove = await shared.remove("user");
                  if(remove == true){
                    Get.offAllNamed(SIGN_IN_SCREEN);
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
              ),
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


  String changeDateFormat(String date){
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }
  
}
