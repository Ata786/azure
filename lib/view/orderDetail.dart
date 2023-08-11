import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:azure/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/productsModel.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  bool loading = true;
  List<ProductsModel> productsList = [];
  double totalWeight = 0.0;
  double totalAmount = 0.0;
  int totalQuantity = 0;

  int radio = 0;

  void getSelectedProducts()async{
    var box = await Hive.openBox("productsBox");
    List<dynamic> data = box.get("products") ?? [];
    List<dynamic> list = data.where((element) => element.subTotal != null).toList();
    productsList = list.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName,
        netRate: e.netRate,quantity: e.quantity,subTotal: e.subTotal,retail: e.retail)).toList();

    for(int i=0; i<productsList.length; i++){
      totalWeight += double.tryParse(productsList[i].wgm.toString())!;
      totalAmount += double.tryParse(productsList[i].subTotal.toString())!;
      totalQuantity += int.tryParse(productsList[i].quantity.toString())!;
    }
    loading = false;
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getSelectedProducts();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title: textWidget(text: "Order Detail", fontSize: FetchPixels.getPixelHeight(16),textColor: Colors.white, fontWeight: FontWeight.w600),automaticallyImplyLeading: false,
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Container(
              height: FetchPixels.getPixelHeight(100),
              width: FetchPixels.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    height: FetchPixels.getPixelHeight(70),
                    width: FetchPixels.getPixelWidth(200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10),vertical: FetchPixels.getPixelHeight(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(text: "Sort By", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                            Row(
                              children: [
                                Radio(value: true, groupValue: true, onChanged: (v){},activeColor: Colors.pinkAccent,),
                                textWidget(text: "Details", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                                Radio(value: false, groupValue: true, onChanged: (v){},activeColor: Colors.pinkAccent,),
                                textWidget(text: "SKU", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: FetchPixels.getPixelHeight(70),
                    width: FetchPixels.getPixelWidth(300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10),vertical: FetchPixels.getPixelHeight(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(text: "Payment Method", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                            Row(
                              children: [
                                Radio(value: radio == 0 ? true : false, groupValue: true, onChanged: (v){
                                  setState(() {
                                    radio = 0;
                                  });
                                },activeColor: Colors.pinkAccent,),
                                textWidget(text: "Credit", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                                Radio(value: radio == 1 ? true : false, groupValue: true, onChanged: (v){
                                 setState(() {
                                   radio = 1;
                                 });
                                },activeColor: Colors.pinkAccent,),
                                textWidget(text: "Cash", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                                Radio(value: radio == 2 ? true : false, groupValue: true, onChanged: (v){
                                  setState(() {
                                    radio = 2;
                                  });
                                },activeColor: Colors.pinkAccent,),
                                textWidget(text: "Check", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,),
            Expanded(
                child: loading == true ? Center(child: CircularProgressIndicator(color: themeColor,),)
                :  ListView.builder(
                  itemCount: productsList.length,
                    itemBuilder: (context,index) {
              return InkWell(
                onTap: ()async{

                },
                child: Container(
                    margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(10),left: FetchPixels.getPixelWidth(20),right: FetchPixels.getPixelWidth(20)),
                    width: FetchPixels.width,
                    height: FetchPixels.getPixelHeight(120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(text: productsList[index].pname ?? "", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: primaryColor),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                textWidget(text: "Quantity: ${productsList[index].quantity}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                textWidget(text: 'Total Weight: ${double.tryParse(productsList[index].quantity.toString())! * double.tryParse(productsList[index].wgm.toString())!}', fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: FetchPixels.getPixelHeight(30),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(text: "Weight:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                    SizedBox(width: FetchPixels.getPixelWidth(10),),
                                    textWidget(text: "${productsList[index].wgm}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                  ],
                                ),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(text: "Rate:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                    SizedBox(width: FetchPixels.getPixelWidth(10),),
                                    textWidget(text: "${productsList[index].netRate}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                  ],
                                ),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(text: "SubTotal:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                    SizedBox(width: FetchPixels.getPixelWidth(10),),
                                    textWidget(text: "${productsList[index].subTotal}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: FetchPixels.getPixelHeight(0.5),
                          color: Colors.black.withOpacity(0.5),
                          width: FetchPixels.width,
                        )
                      ],
                    )
                ),
              );
            })),
            Container(
              margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              height: FetchPixels.getPixelHeight(100),
              width: FetchPixels.width,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textWidget(text: "Total Quantity", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "Total Weight", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "Total Amount", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                         ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textWidget(text: "$totalAmount", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "$totalWeight", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "$totalQuantity", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Padding(
              padding: EdgeInsets.only(right: FetchPixels.getPixelWidth(25)),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: ()async{
                    var box = await Hive.openBox("productsBox");
                    List<dynamic> data = box.get("products") ?? [];
                    List<ProductsModel> p = data.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName,
                        netRate: e.netRate,quantity: e.quantity,subTotal: e.subTotal,retail: e.retail)).toList();

                    for(int i=0; i<p.length; i++){
                      print('>>> ${p[i].toJson()}');
                    }

                  },
                  child: button(height: FetchPixels.getPixelHeight(30),
                      width: FetchPixels.getPixelWidth(130),
                      color: themeColor,
                      textColor: Colors.white,
                      textSize: FetchPixels.getPixelHeight(10),
                      borderRadius: FetchPixels.getPixelHeight(8), textWeight: FontWeight.w500, text: "CHECK OUT"),
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
          ],
        ),
      ),
    );
  }
}
