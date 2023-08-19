import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/hiveDb.dart';
import '../model/NewShopModel.dart';
import '../res/images.dart';
import '../utils/widgets/appWidgets.dart';
import 'NewShops.dart';

class TodayNewShops extends StatefulWidget {
  TodayNewShops({super.key});

  @override
  State<TodayNewShops> createState() => _TodayNewShopsState();
}

class _TodayNewShopsState extends State<TodayNewShops> {

  List<NewShopModel> todayNewShops = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getShops();
  }

  void getShops()async{
    todayNewShops = await HiveDatabase.getNewShops("NewShopsBox", "NewShops");
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title:  textWidget(
          textColor: Colors.white,
          text: "Today New Shop",
          fontSize: FetchPixels.getPixelHeight(17),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: loading == true ? Center(child: CircularProgressIndicator(color: themeColor,),) : ListView.builder(
            itemCount: todayNewShops.length,
            itemBuilder: (context,index){
          return Container(
              height: FetchPixels.getPixelHeight(60),
              width: FetchPixels.width,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(
                            textColor: Colors.black,
                            text: todayNewShops[index].shopName ?? "",
                            fontSize: FetchPixels.getPixelHeight(17),
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(10),),
                          textWidget(
                            textColor: Colors.black,
                            text: todayNewShops[index].shopAddress ?? "",
                            fontSize: FetchPixels.getPixelHeight(12),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: (){
                                Get.off(NewShops(isEdit: false,todayShopEdit: true,newShopModel: todayNewShops[index]));
                              },
                              child: Image.asset(editing,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),)),
                          SizedBox(width: FetchPixels.getPixelWidth(25),),
                          InkWell(
                              onTap: (){
                                Get.dialog(
                                    AlertDialog(
                                      content: Container(
                                        height: FetchPixels.getPixelHeight(100),
                                        width: FetchPixels.width,
                                        child: Column(
                                          children: [
                                            textWidget(
                                              textColor: Colors.black,
                                              text: "Do you want to delete this record?",
                                              fontSize: FetchPixels.getPixelHeight(16),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(height: FetchPixels.getPixelHeight(20),),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Get.back();
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(5.0),
                                                      child: textWidget(text: "No", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: ()async{
                                                    var box = await Hive.openBox("NewShopsBox");
                                                    todayNewShops.removeAt(index);
                                                    box.put("NewShops", todayNewShops);
                                                    getShops();
                                                    Get.back();
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(5.0),
                                                      child: textWidget(text: "Yes", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.green),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                );
                              },
                              child: Image.asset(bin,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),)),
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,),
                  SizedBox(height: FetchPixels.getPixelHeight(5),)
                ],
              )
          );
        }),
      ),
    );
  }
}
