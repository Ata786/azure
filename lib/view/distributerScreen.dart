import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistributerScreen extends StatefulWidget {
  DistributerScreen({super.key});

  @override
  State<DistributerScreen> createState() => _DistributerScreenState();
}

class _DistributerScreenState extends State<DistributerScreen> {
  TextEditingController searchCtr = TextEditingController();

  bool msValue = false;
  bool galaxyValue = false;
  bool madinaValue = false;
  bool i = false;

  List<String> companyList = ["Company1","Company2"];
  String companyValue = "Company1";

  List<String> regionList = ["Region1","Region2"];
  String regionValue = "Region1";

  List<String> areaList = ["Area1","Area2"];
  String areaValue = "Area1";

  List<String> teritoryList = ["Teritory1","Teritory2"];
  String teritoryValue = "Teritory1";

  List<String> townList = ["Town1","Town2"];
  String townValue = "Town1";



  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title:  textWidget(text: "Distributions", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Center(child: textWidget(text: "Back", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white))),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              i == true ? Container(
                height: FetchPixels.getPixelHeight(250),
                width: FetchPixels.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(text: "Company", fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                value: companyValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    companyValue = newValue!;
                                  });
                                },
                                items: companyList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value ?? ""),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),),
                        Expanded(child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(text: "Region", fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                value: regionValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    regionValue = newValue!;
                                  });
                                },
                                items: regionList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value ?? ""),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        ),),
                      ],
                    ),
                    SizedBox(height: FetchPixels.getPixelHeight(10),),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(text: "Area", fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                value: areaValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    areaValue = newValue!;
                                  });
                                },
                                items: areaList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value ?? ""),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),),
                        Expanded(child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(text: "Teritory", fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  value: teritoryValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      teritoryValue = newValue!;
                                    });
                                  },
                                  items: teritoryList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value ?? ""),
                                    );
                                  }).toList(),
                                ),
                              ],
                            )
                        ),),
                      ],
                    ),
                    SizedBox(height: FetchPixels.getPixelHeight(10),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(text: "Town", fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            value: townValue,
                            onChanged: (newValue) {
                              setState(() {
                                townValue = newValue!;
                              });
                            },
                            items: townList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value ?? ""),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ) : SizedBox(),
              i == true ? SizedBox(height: FetchPixels.getPixelHeight(10),) : SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                      child: textField(
                          controller: searchCtr,
                          hintText: "Search..."),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        i = !i;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                      width: FetchPixels.getPixelWidth(100),height: FetchPixels.getPixelHeight(50),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.filter_alt_sharp),
                          textWidget(text: "Filter", fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              distributionWidget(onChange: (value){
                setState(() {
                  msValue = !msValue;
                });
              }, text: "M.S Traders",value: msValue),
              distributionWidget(onChange: (value){
                setState(() {
                  galaxyValue = !galaxyValue;
                });
              }, text: "Galaxy United",value: galaxyValue),
              distributionWidget(onChange: (value){
                setState(() {
                  madinaValue = !madinaValue;
                });
              }, text: "Madina Traders",value: madinaValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget distributionWidget({required Function(bool?) onChange,required String text,required bool value}){
    return Row(
      children: <Widget>[
        Checkbox(
          value: value,
          onChanged: onChange,
        ),
        textWidget(text: text,fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
      ],
    );
  }


}
