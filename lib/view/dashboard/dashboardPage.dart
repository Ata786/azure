import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboardController.dart';
import '../../data/getApis.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    DashBoardController dashBoardController = Get.find<DashBoardController>();
    FetchPixels(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            Container(
              height: FetchPixels.getPixelHeight(70),
              width: FetchPixels.width,
              decoration: BoxDecoration(color: themeColor.withOpacity(0.3)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      dashBoardController.performanceDay.value = 0;
                      pageController.animateToPage(
                          dashBoardController.performanceDay.value,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Obx(() => Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              textWidget(
                                  text: "This Week",
                                  fontSize: FetchPixels.getPixelHeight(15),
                                  fontWeight: FontWeight.w500,
                                  textColor: dashBoardController
                                              .performanceDay.value ==
                                          0
                                      ? Colors.white
                                      : Colors.black),
                              dashBoardController.performanceDay.value == 0
                                  ? Container(
                                      height: FetchPixels.getPixelHeight(2),
                                      color: themeColor,
                                    )
                                  : SizedBox()
                            ],
                          ),
                        )),
                  )),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            dashBoardController.performanceDay.value = 1;
                            pageController.animateToPage(
                                dashBoardController.performanceDay.value,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  textWidget(
                                      text: "This Month",
                                      fontSize: FetchPixels.getPixelHeight(15),
                                      fontWeight: FontWeight.w500,
                                      textColor: dashBoardController
                                                  .performanceDay.value ==
                                              1
                                          ? Colors.white
                                          : Colors.black),
                                  dashBoardController.performanceDay.value == 1
                                      ? Container(
                                          height: FetchPixels.getPixelHeight(2),
                                          color: themeColor,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ))),
                ],
              ),
            ),
            Expanded(
                child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Obx(() => dashBoardController.weekCheck.value == true ? Center(child: CircularProgressIndicator(color: themeColor,))
                  : dashBoardController.weekPerformanceModel.value.currentPjPShops == null ? SizedBox() : Container(
                      padding: EdgeInsets.symmetric(
                          vertical: FetchPixels.getPixelHeight(10),
                          horizontal: FetchPixels.getPixelWidth(10)),
                      margin: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(10),
                          vertical: FetchPixels.getPixelHeight(7)),
                      width: FetchPixels.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5, // Spread radius
                              blurRadius: 10, // Blur radius
                              offset: Offset(0, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(8))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              performanceTextWidget(
                                  text: "CurrentPjPShops"),
                              performanceTextWidget(text: "PjPShops"),
                              performanceTextWidget(
                                  text: "VisitedShops"),
                              performanceTextWidget(
                                  text: "PoroductiveShops"),
                              performanceTextWidget(
                                  text: "UniqueProductivety"),
                              performanceTextWidget(
                                  text: "NoOfInvoices"),
                              performanceTextWidget(
                                  text: "AverageDropSize"),
                              // performanceTextWidget(
                              //     text: "AverageSale"),
                              // performanceTextWidget(
                              //     text: "Frequency"),
                              performanceTextWidget(text: "Lppc"),
                              performanceTextWidget(
                                  text: "TotalTonage"),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  dashBoardController.weekPerformanceModel.value.brandTonageSale.isEmpty
                                      ? 0
                                      : dashBoardController.weekPerformanceModel.value.brandTonageSale.length,
                                      (index) => performanceTextWidget(
                                    text: dashBoardController.weekPerformanceModel.value.brandTonageSale.isEmpty
                                        ? ""
                                        : dashBoardController.weekPerformanceModel.value.brandTonageSale[
                                    index]
                                        .brandName ??
                                        "",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.currentPjPShops == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.currentPjPShops ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.pjPShops== null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.pjPShops ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.visitedShops == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.visitedShops ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.productiveShops == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.productiveShops ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.uniqueProductivety == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.uniqueProductivety ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.totalTonage == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.noOfInvoices ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.averageDropSize == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.averageDropSize.toStringAsFixed(3) ?? ""}",
                                ),
                                // performanceTextWidget(
                                //   text: dashBoardController.weekPerformanceModel.value.averageSale == null
                                //       ? ""
                                //       : "${dashBoardController.weekPerformanceModel.value.averageSale.toStringAsFixed(3) ?? ""}",
                                // ),
                                // performanceTextWidget(
                                //   text: dashBoardController.weekPerformanceModel.value.frequency == null
                                //       ? ""
                                //       : "${dashBoardController.weekPerformanceModel.value.frequency.toStringAsFixed(3) ?? ""}",
                                // ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.lppc == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.lppc.toStringAsFixed(3) ?? ""}",
                                ),
                                performanceTextWidget(
                                  text: dashBoardController.weekPerformanceModel.value.totalTonage == null
                                      ? ""
                                      : "${dashBoardController.weekPerformanceModel.value.totalTonage.toStringAsFixed(3) ?? ""}",
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    dashBoardController.weekPerformanceModel.value.brandTonageSale.isEmpty
                                        ? 0
                                        : dashBoardController.weekPerformanceModel.value
                                        .brandTonageSale.length,
                                        (index) => performanceTextWidget(
                                      text:     dashBoardController.weekPerformanceModel.value.brandTonageSale.isEmpty
                                          ? ""
                                          : dashBoardController.weekPerformanceModel.value
                                          .brandTonageSale[
                                      index]
                                          .totalTonage.toStringAsFixed(3) ??
                                          "",
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      )),),
                Obx(() => dashBoardController.monthCheck.value == true ? Center(child: CircularProgressIndicator(color: themeColor,))
                    : dashBoardController.monthPerformanceModel.value.currentPjPShops == null ? SizedBox() : Container(
                    padding: EdgeInsets.symmetric(
                        vertical: FetchPixels.getPixelHeight(10),
                        horizontal: FetchPixels.getPixelWidth(10)),
                    margin: EdgeInsets.symmetric(
                        horizontal: FetchPixels.getPixelWidth(10),
                        vertical: FetchPixels.getPixelHeight(7)),
                    width: FetchPixels.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(8))),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            performanceTextWidget(
                                text: "CurrentPjPShops"),
                            performanceTextWidget(text: "PjPShops"),
                            performanceTextWidget(
                                text: "VisitedShops"),
                            performanceTextWidget(
                                text: "PoroductiveShops"),
                            performanceTextWidget(
                                text: "UniqueProductivety"),
                            performanceTextWidget(
                                text: "NoOfInvoices"),
                            performanceTextWidget(
                                text: "AverageDropSize"),
                            // performanceTextWidget(
                            //     text: "AverageSale"),
                            // performanceTextWidget(
                            //     text: "Frequency"),
                            performanceTextWidget(text: "Lppc"),
                            performanceTextWidget(
                                text: "TotalTonage"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                dashBoardController.monthPerformanceModel.value.brandTonageSale.isEmpty
                                    ? 0
                                    : dashBoardController.monthPerformanceModel.value.brandTonageSale.length,
                                    (index) => performanceTextWidget(
                                  text: dashBoardController.monthPerformanceModel.value.brandTonageSale.isEmpty
                                      ? ""
                                      : dashBoardController.monthPerformanceModel.value.brandTonageSale[
                                  index]
                                      .brandName ??
                                      "",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.currentPjPShops == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.currentPjPShops ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.pjPShops== null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.pjPShops ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.visitedShops == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.visitedShops ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.productiveShops == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.productiveShops ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.uniqueProductivety == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.uniqueProductivety ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.totalTonage == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.noOfInvoices ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.averageDropSize == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.averageDropSize.toStringAsFixed(3) ?? ""}",
                              ),
                              // performanceTextWidget(
                              //   text: dashBoardController.monthPerformanceModel.value.averageSale == null
                              //       ? ""
                              //       : "${dashBoardController.monthPerformanceModel.value.averageSale.toStringAsFixed(3) ?? ""}",
                              // ),
                              // performanceTextWidget(
                              //   text: dashBoardController.monthPerformanceModel.value.frequency == null
                              //       ? ""
                              //       : "${dashBoardController.monthPerformanceModel.value.frequency.toStringAsFixed(3) ?? ""}",
                              // ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.lppc == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.lppc.toStringAsFixed(3) ?? ""}",
                              ),
                              performanceTextWidget(
                                text: dashBoardController.monthPerformanceModel.value.totalTonage == null
                                    ? ""
                                    : "${dashBoardController.monthPerformanceModel.value.totalTonage.toStringAsFixed(3) ?? ""}",
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  dashBoardController.monthPerformanceModel.value.brandTonageSale.isEmpty
                                      ? 0
                                      : dashBoardController.monthPerformanceModel.value
                                      .brandTonageSale.length,
                                      (index) => performanceTextWidget(
                                    text:     dashBoardController.monthPerformanceModel.value.brandTonageSale.isEmpty
                                        ? ""
                                        : dashBoardController.monthPerformanceModel.value
                                        .brandTonageSale[
                                    index]
                                        .totalTonage.toStringAsFixed(3) ??
                                        "",
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    )),),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
