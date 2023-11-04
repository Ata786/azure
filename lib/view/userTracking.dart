import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/userTrackLocationModel.dart';
import 'package:http/http.dart' as http;
import 'package:SalesUp/model/userTrackingModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/view/trackMap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserTrackingScreen extends StatefulWidget {
  List<UserTrackingModel> userTrackingList = [];
  UserTrackingScreen(this.userTrackingList,{super.key});

  @override
  State<UserTrackingScreen> createState() => _UserTrackingScreenState();
}

class _UserTrackingScreenState extends State<UserTrackingScreen> {


  TextEditingController toDateCtr = TextEditingController();
  DateTime now = DateTime.now();

  UserTrackingModel userValue = UserTrackingModel();
  UserTrackingModel desigValue = UserTrackingModel();

  @override
  void initState() {
    super.initState();

    toDateCtr.text = DateFormat("dd-MM-yyyy").format(now);

    userValue = widget.userTrackingList[0];

    desigValue = widget.userTrackingList[0];


  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          "User Tracking",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Container(
              alignment: Alignment.centerLeft,
              width: FetchPixels.width/2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                child: TextField(
                  readOnly: true,
                  enabled: true,
                  onTap: (){
                    showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2050),
                    ).then((selectedDate) {
                      if(selectedDate != null){
                        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                        toDateCtr.text = formattedDate;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "From Date",
                      suffixIcon: Icon(Icons.calendar_month)
                  ),
                  controller: toDateCtr,
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Expanded(flex: 1,child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
                  child: DropdownButtonFormField<UserTrackingModel>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: desigValue,
                    onChanged: (newValue) {
                      desigValue = newValue!;
                    },
                    items: widget.userTrackingList.map<DropdownMenuItem<UserTrackingModel>>((UserTrackingModel value) {
                      return DropdownMenuItem<UserTrackingModel>(
                        value: value,
                        child: Text(value.designation ?? ""),
                      );
                    }).toList(),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
                    child: DropdownButtonFormField<UserTrackingModel>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      value: userValue,
                      onChanged: (newValue) {
                        userValue = newValue!;
                        setState(() {

                        });
                      },
                      items: widget.userTrackingList.map<DropdownMenuItem<UserTrackingModel>>((UserTrackingModel value) {
                        return DropdownMenuItem<UserTrackingModel>(
                          value: value,
                          child: Text(value.fullName ?? ""),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            InkWell(
              onTap: ()async{
                List<UserTrackLocationModel> userTrackingLocation = [];
                userTrackingLocation = await userTrackLocationApi(userValue.email ?? "", toDateCtr.text);
                Get.to(TrackMap(userTrackingLocation));
              },
              child: Container(
                alignment: Alignment.center,
                height: FetchPixels.height / 18,
                width: FetchPixels.width/4,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(7)),
                child:  Text(
                  "Track",
                  style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(15),fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<List<UserTrackLocationModel>> userTrackLocationApi(String email,String date)async{

    List<UserTrackLocationModel> userTrackLocationModel = [];


    try{

      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

      DateFormat inputFormat = DateFormat("dd-MM-yyyy");
      DateTime inputDate = inputFormat.parse(date);


      Map<String,dynamic> data = {
        "email": email,
        "date":  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(inputDate),
      };

      log('>>> ${data}');

      var res = await http.post(Uri.parse('$BASE_URL/UserLive/GetUserLive'),headers: {
        'Content-Type': 'application/json',
      },body: jsonEncode(data));

      Get.back();

      if(res.statusCode ==  200){


        List<dynamic> json = jsonDecode(res.body);
        userTrackLocationModel = json.map((e) => UserTrackLocationModel.fromJson(e)).toList();

      }else{
        Get.back();

        log('>>>> Error ${res.body}');
      }


    }catch(e){
      Get.back();
      log('>>>> exception ${e.toString()}');
    }
    return userTrackLocationModel;
  }



}
