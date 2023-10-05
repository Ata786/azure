import 'dart:developer';

import 'package:SalesUp/model/distributionModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/distributionController.dart';
import '../data/hiveDb.dart';

class DistributerScreen extends StatefulWidget {
  DistributerScreen({super.key});

  @override
  State<DistributerScreen> createState() => _DistributerScreenState();
}

class _DistributerScreenState extends State<DistributerScreen> {
  TextEditingController searchCtr = TextEditingController();

  bool msValue = true;
  bool galaxyValue = false;
  bool madinaValue = false;
  bool i = false;
  List<int> checkIndex = [];

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

  List<DistributionModel> distributionList = [];
  String searchQuery = '';

  @override
  void initState() {
    getDistribution();
    super.initState();
  }

  bool show = false;

  void getDistribution()async{
    DistributionController distributionController = Get.find<DistributionController>();
    distributionList = distributionController.distributionList;

    setState(() {

    });
  }


  void onSearchQueryChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  List<DistributionModel> getFilteredDistributionList() {
    return distributionList.where((distribution) => distribution.distributorName
        !.toLowerCase()
        .contains(searchQuery.toLowerCase())).toList();
  }


  @override
  Widget build(BuildContext context) {
    DistributionController distributionController = Get.find<DistributionController>();
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: (){
              distributionController.distributorIdList.clear();
              List<int> selected = distributionController.selectedItems.map((e) => e.distributorId ?? 0).toList();
              distributionController.distributorIdList.addAll(selected);
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: themeColor,
        title:  textWidget(text: "Select Distributions", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  show == true ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                      child: textField(
                          onChange: onSearchQueryChanged,
                          controller: searchCtr,
                          hintText: "Search..."),
                    ),
                  ) : SizedBox(),
                  InkWell(
                      onTap: (){
                        setState(() {
                          show = !show;
                          searchCtr.text = '';
                        });
                      },
                      child: Icon(show == true ? Icons.close : Icons.search)),
                  SizedBox(width: FetchPixels.getPixelWidth(10)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: ()async{
                      List<DistributionModel> list = await HiveDatabase.getDistributionList("distribution", "distributionBox");
                      distributionController.distributionList.value = list;
                      distributionController.distributorIdList.clear();
                      List<int> distributorIds = list.map((e) => e.distributorId ?? 0).toList();
                      distributionController.distributorIdList.addAll(distributorIds);

                      distributionController.selectedItems.clear();
                      distributionController.selectedItems.addAll(list);
                      setState(() {

                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                        width: FetchPixels.getPixelWidth(80),height: FetchPixels.getPixelHeight(40),
                        decoration: BoxDecoration(
                          color: themeColor,
                        ),
                        child: Center(
                          child:    textWidget(text: "Select All", fontSize: FetchPixels.getPixelHeight(11), fontWeight: FontWeight.w500,textColor: Colors.white),
                        )
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      if(distributionController.selectedItems.isNotEmpty){
                        distributionController.selectedItems.clear();
                        setState(() {

                        });
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                        width: FetchPixels.getPixelWidth(80),height: FetchPixels.getPixelHeight(40),
                        decoration: BoxDecoration(
                          color: themeColor,
                        ),
                        child: Center(
                          child:    textWidget(text: "UnSelect All", fontSize: FetchPixels.getPixelHeight(11), fontWeight: FontWeight.w500,textColor: Colors.white),
                        )
                    ),
                  ),
                ],
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Column(
                children: List.generate(getFilteredDistributionList().length,
                    (index){
                      final distributionItem = getFilteredDistributionList()[index];
                  return Row(
                    children: <Widget>[
                      Checkbox(
                        value: distributionController.selectedItems.contains(distributionItem),
                        onChanged: (value){
                          setState(() {
                            if (value!) {
                              distributionController.selectedItems.add(distributionItem);
                            } else {
                              distributionController.selectedItems.remove(distributionItem);
                            }
                          });
                        },
                      ),
                      textWidget(text: distributionItem.distributorName ?? "",fontSize: FetchPixels.getPixelHeight(17), fontWeight: FontWeight.w500,textColor: Colors.black),
                    ],
                  );
                    }),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
