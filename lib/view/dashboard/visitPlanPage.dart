import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/allStoresWidget.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/NonProductive.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:SalesUp/view/sessionTimeOut.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/widgets/productiveStores.dart';

class VisitPlan extends StatefulWidget {
  VisitPlan({super.key});

  @override
  State<VisitPlan> createState() => _VisitPlanState();
}

class _VisitPlanState extends State<VisitPlan> {
  TextEditingController searchCtr = TextEditingController();

  PageController pageController = PageController();
  int page = 0;

  bool search = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SyncNowController syncNowController = Get.find<SyncNowController>();
    UserController userController = Get.find<UserController>();
    FetchPixels(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: FetchPixels.getPixelHeight(10),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap:(){
                        syncNowController.syncDownList.sort();
                      },
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: FetchPixels.getPixelWidth(10),
                    ),
                    search == false ? InkWell(
                      onTap: (){
                        setState(() {
                          search = true;
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    )
                    : Container(
                      height: FetchPixels.getPixelHeight(40),
                      width: FetchPixels.getPixelWidth(200),
                      child: TextField(
                        onChanged: (v) {
                          if(page == 1){
                            syncNowController.filteredReasonList.value = syncNowController.reasonModelList
                                .where((item) => item.shopName!.toLowerCase().contains(v.toLowerCase()))
                                .toList();
                          }else{
                            syncNowController.searchList.value = syncNowController.allList
                                .where((item) => item.shopname!.toLowerCase().contains(v.toLowerCase()))
                                .toList();
                          }
                        },
                        controller: searchCtr,
                        decoration: InputDecoration(
                          hintText: "Search Shops",
                          suffixIcon: InkWell(
                              onTap: (){
                                setState(() {
                                  search = false;
                                  searchCtr.text = '';
                                  if(page == 1){
                                    syncNowController.filteredReasonList.value = syncNowController.reasonModelList;
                                  }else{
                                    syncNowController.searchList.value = syncNowController.allList;
                                  }
                                });
                              },
                              child: Icon(Icons.close)),
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: (){
                    // Get.dialog(
                    //   SessionTimeOut()
                    // );
                    Get.dialog(
                      DistributerScreen()
                    );
                  },
                  child: buttonWithIcon(
                      color: themeColor,
                      textColor: Colors.white,
                      textSize: FetchPixels.getPixelHeight(15),
                      borderRadius: 20.0,
                      textWeight: FontWeight.w500,
                      text: "Add"),
                )
              ],
            ),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(10),
          ),
          Container(
            height: FetchPixels.getPixelHeight(75),
            width: FetchPixels.width,
            padding:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            color: Color(0xff616161),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textWidget(
                          textColor: Colors.white,
                          text: "Booking Value:",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        ),
                        textWidget(
                          textColor: Colors.white,
                          text: "LPPC:",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        ),
                        textWidget(
                          textColor: Colors.white,
                          text: "Qty (Nos):",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: FetchPixels.getPixelWidth(11),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() => textWidget(
                          textColor: Colors.white,
                          text: syncNowController.orderCalculationModel.value.bookingValue == null ? "0" : "${syncNowController.orderCalculationModel.value.bookingValue!.toStringAsFixed(3) ?? 0}",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        )),
                        Obx(() => textWidget(
                          textColor: Colors.white,
                          text: syncNowController.orderCalculationModel.value.llpc == null ? "0" :"${syncNowController.orderCalculationModel.value.llpc!.toStringAsFixed(3) ?? 0}",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        )),
                        Obx(() => textWidget(
                          textColor: Colors.white,
                          text: syncNowController.orderCalculationModel.value.qty == null ? "0" :"${syncNowController.orderCalculationModel.value.qty!.toStringAsFixed(0) ?? 0}",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        )),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textWidget(
                          textColor: Colors.white,
                          text: "Productive Call:",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        ),
                        textWidget(
                          textColor: Colors.white,
                          text: "Weight(Ltr / Kg):",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        ),
                        textWidget(
                          textColor: Colors.white,
                          text: "Tonage:",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: FetchPixels.getPixelWidth(11),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() => textWidget(
                          textColor: Colors.white,
                          text: "${syncNowController.reasonModelList.length}/${syncNowController.syncDownList.length}",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        )),
                        Obx(() => textWidget(
                          textColor: Colors.white,
                          text: syncNowController.orderCalculationModel.value.weight == null ? "0" :"${syncNowController.orderCalculationModel.value.weight!.toStringAsFixed(4) ?? 0}",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        )),
                        Obx(() => textWidget(
                          textColor: Colors.white,
                          text: syncNowController.orderCalculationModel.value.tonnage == null ? "0" :"${syncNowController.orderCalculationModel.value.tonnage!.toStringAsFixed(4) ?? 0}",
                          fontSize: FetchPixels.getPixelHeight(11),
                          fontWeight: FontWeight.w400,
                        )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(20),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      page = 0;
                      pageController.animateToPage(page, duration:Duration(milliseconds: 500), curve: Curves.easeInOut);
                    });
                  },
                  child: Obx(() => textWidget(
                    textColor: page == 0 ? primaryColor : Color(0xffd2d2d2),
                    text: "All Shops ${syncNowController.syncDownList.length}",
                    fontSize: FetchPixels.getPixelHeight(15),
                    fontWeight: FontWeight.w400,
                  )),
                ),
                Container(
                  height: FetchPixels.getPixelHeight(15),
                  width: FetchPixels.getPixelWidth(1),
                  color: Color(0xffd2d2d2),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      page = 1;
                      pageController.animateToPage(page, duration:Duration(milliseconds: 500), curve: Curves.easeInOut);
                    });
                  },
                  child: Obx(() => textWidget(
                    textColor: page == 1 ? primaryColor :  Color(0xffd2d2d2),
                    text: "Productive ${syncNowController.reasonModelList.length}",
                    fontSize: FetchPixels.getPixelHeight(15),
                    fontWeight: FontWeight.w400,
                  )),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      page = 2;
                      pageController.animateToPage(page, duration:Duration(milliseconds: 500), curve: Curves.easeInOut);
                    });
                  },
                  child: Obx(() => textWidget(
                    textColor: page == 2 ? primaryColor : Color(0xffd2d2d2),
                    text: "Non Productive ${syncNowController.syncDownList.where((p0) => p0.productive == false).length}",
                    fontSize: FetchPixels.getPixelHeight(15),
                    fontWeight: FontWeight.w400,
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(5),
          ),
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            height: FetchPixels.getPixelHeight(1),
            width: FetchPixels.width,
            color: primaryColor.withOpacity(0.5),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(20),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (p){
                setState(() {
                  page = p;
                });
              },
              controller: pageController,
              children: [
                allStores(syncNowController: syncNowController, userController: userController),
                productiveStore(syncNowController: syncNowController),
               NonProductiveShops(syncNowController: syncNowController, userController: userController)
              ],
            ),
          )
        ],
      ),
    );
  }


}
