import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/assignUserModel.dart';
import 'package:SalesUp/model/userTrackLocationModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  // UserTrackingModel userValue = UserTrackingModel();
  UserTrackingModel desigValue = UserTrackingModel();

  UserAssignModel typeValue = UserAssignModel();

  List<String> userDesignationList = [];
  String designation = "";
  UserAssignModel userValue = UserAssignModel();

  List<UserAssignModel> personsList = [];

  @override
  void initState() {
    super.initState();

    toDateCtr.text = DateFormat("dd-MM-yyyy").format(now);
    // userValue = widget.userTrackingList[0];
    desigValue = widget.userTrackingList[0];

    UserController userController = Get.find<UserController>();

    personsList.addAll(userController.userAssignList);
    userValue = personsList[0];

    typeValue.fullName = userController.userAssignList[0].fullName ?? "";

    userDesignationList = getDesignations(userController.userAssignList);
    userDesignationList.insert(0, "All");
    designation = userDesignationList[0];
    getUsers();

  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
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
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: designation,
                    onChanged: (newValue) {
                      designation = newValue!;

                      if(designation == "All"){

                        List<UserAssignModel>  list = userController.userAssignList;

                        personsList.clear();
                        personsList.addAll(list);
                        userValue = personsList[0];
                        setState(() {

                        });

                      }else{
                        List<UserAssignModel>  list = userController.userAssignList.where((element) => element.designation == designation).toList();

                        personsList.clear();
                        personsList.addAll(list);
                        userValue = personsList[0];
                        setState(() {

                        });
                      }

                      },
                    items: userDesignationList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value ?? ""),
                      );
                    }).toList(),
                  ),
                )),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
                    child: DropdownButtonFormField<UserAssignModel>(
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
                      items: personsList.map<DropdownMenuItem<UserAssignModel>>((UserAssignModel value) {
                        return DropdownMenuItem<UserAssignModel>(
                          value: value,
                          child: Text(value.fullName ?? ""),
                        );
                      }).toList()..sort((a, b) => (a.value?.fullName ?? "").compareTo(b.value?.fullName ?? "")),
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
                if(userTrackingLocation.isEmpty){
                  Fluttertoast.showToast(
                      msg: "Data Not Found",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: themeColor,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }else{
                  Get.to(TrackMap(userTrackingLocation));
                }
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

      if(res.statusCode ==  200){
        Get.back();

        log('>>>>> ${res.body}');

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


  void getUsers()async{

    UserController userController = Get.find<UserController>();
    getDesignations(userController.userAssignList);

    setState(() {

    });

  }



  List<String> getDesignations(List<UserAssignModel> userDesignationList) {
    final designations = <String>[];

    for (final userAssignModel in userDesignationList) {
      final designation = userAssignModel.designation;

      if (!designations.contains(designation)) {
        designations.add(designation ?? "");
      }
    }

    return designations;
  }



}
