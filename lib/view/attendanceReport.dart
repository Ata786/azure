import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/assignUserModel.dart';
import 'package:SalesUp/model/attendanceDetailModel.dart';
import 'package:SalesUp/model/userTrackingModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/attendanceDetail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AttendanceReportScreen extends StatefulWidget {
  AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  List<String> typeDropDown = ["Select Person"];

  String typeValue = "Select Person";
  String designation = "";
  TextEditingController fromDateCtr = TextEditingController();
  TextEditingController toDateCtr = TextEditingController();
  DateTime now = DateTime.now();

  List<UserTrackingModel> userList = [];
  List<AttendanceDetailsModel> attendanceDetailList = [];

  List<String> userDesignationList = [];

  String selectedEmail = "";


  @override
  void initState() {
    super.initState();
    fromDateCtr.text = DateFormat("dd-MM-yyyy").format(now);
    toDateCtr.text = DateFormat("dd-MM-yyyy").format(now);
    UserController userController = Get.find<UserController>();

    userDesignationList = getDesignations(userController.userAssignList);
    userDesignationList.insert(0, "All");
    designation = userDesignationList[0];
    getUsers();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      attendanceDetailList = await attendanceDetailApi();
    });
  }

  void getUsers()async{

    UserController userController = Get.find<UserController>();
    typeValue = userController.userAssignList[0].fullName ?? "";
    selectedEmail = userController.userAssignList[0].email ?? "";
    getDesignations(userController.userAssignList);
    // userList = await userTrackingApis();
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



  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title:  textWidget(text: "Attendance Report", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                Expanded(
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
                          fromDateCtr.text = formattedDate;
                        }
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "From Date",
                        suffixIcon: Icon(Icons.calendar_month)
                    ),
                    controller: fromDateCtr,
                  ),
                ),
                SizedBox(width: FetchPixels.getPixelWidth(20),),
                Expanded(
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
                        hintText: "To Date",
                        suffixIcon: Icon(Icons.calendar_month)
                    ),
                    controller: toDateCtr,
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: FetchPixels.width/2,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  value: designation,
                  onChanged: (newValue) {
                    setState(() {
                      designation = newValue!;
                    });
                  },
                  items: userDesignationList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value ?? ""),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      Get.to(AttendanceLate());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffADD8E6),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "Late Arrival",
                        style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      List<AttendanceDetailsModel> attendanceDetailsModel = await attendanceDetailMultipleApi();
                      if(attendanceDetailsModel.isEmpty){
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
                        Get.to(AttendanceDetail(attendanceDetailsModel,typeValue,late: false));
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xfff7d8ba),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "List",
                        style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                value: typeValue,
                onChanged: (newValue) {
                  setState(() {
                    typeValue = newValue!;
                    UserAssignModel userAssignModel = userController.userAssignList.where((element) => element.fullName == newValue).first;
                  selectedEmail = userAssignModel.email ?? "";
                  });
                },
                items: userController.userAssignList.map<DropdownMenuItem<String>>((UserAssignModel value) {
                  return DropdownMenuItem<String>(
                    value: value.fullName,
                    child: Text(value.fullName ?? ""),
                  );
                }).toList()..sort((a, b) => (a.value ?? "").compareTo(b.value ?? "")),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            InkWell(
              onTap: ()async{
                attendanceDetailList = await attendanceDetailApi();
                if(attendanceDetailList.isEmpty){
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
                  Get.to(AttendanceDetail(attendanceDetailList,typeValue,late: false));
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: FetchPixels.height / 13,
                width: FetchPixels.width/2,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xfff7d8ba),
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  "Detail",
                  style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  Future<List<AttendanceDetailsModel>> attendanceDetailApi()async{

    List<AttendanceDetailsModel> attendanceDetailList = [];

    try{

      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

      DateFormat inputFormat = DateFormat("dd-MM-yyyy");
      DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      DateTime toDt = inputFormat.parse(toDateCtr.text);
      DateTime fromDt = inputFormat.parse(fromDateCtr.text);

      log('>>> ${outputFormat.format(fromDt)} and ${outputFormat.format(toDt)}');

      var res = await http.post(Uri.parse('$BASE_URL/AttendanceFilter/GetDetail?fromDate=${outputFormat.format(fromDt)}&toDate=${outputFormat.format(toDt)}')
      ,headers: {'Content-Type': 'application/json'}
          ,body: jsonEncode([selectedEmail])
      );

      Get.back();

      log('>>>> ${res.statusCode} and ${res.body}');

      if(res.statusCode ==  200){


        List<dynamic> json = jsonDecode(res.body);
        attendanceDetailList = json.map((e) => AttendanceDetailsModel.fromJson(e)).toList();

      }else{
        log('>>>> Error ${res.body}');
      }


    }catch(e){
      log('>>>> exception ${e.toString()}');
    }
    return attendanceDetailList;
  }




  Future<List<AttendanceDetailsModel>> attendanceDetailMultipleApi()async{
    log('>>>> start');
    List<AttendanceDetailsModel> attendanceDetailList = [];
    UserController userController = Get.find<UserController>();

    List<UserAssignModel> userAssignModelList = [];

    if(designation == "All"){
      userAssignModelList = userController.userAssignList;
    }else{
      userAssignModelList = userController.userAssignList.where((element) => element.designation == designation).toList();
    }

    List<String> persons = [];
    persons.clear();
    for(int i=0; i<userAssignModelList.length; i++){
      persons.add(userAssignModelList[i].email ?? "");
    }

    try{

      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

      DateFormat inputFormat = DateFormat("dd-MM-yyyy");
      DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

      DateTime toDt = inputFormat.parse(toDateCtr.text);
      DateTime fromDt = inputFormat.parse(fromDateCtr.text);

      log('>>> ${outputFormat.format(fromDt)} and ${outputFormat.format(toDt)}');

      var res = await http.post(Uri.parse('$BASE_URL/AttendanceFilter/GetDetail?fromDate=${outputFormat.format(fromDt)}&toDate=${outputFormat.format(toDt)}')
          ,headers: {'Content-Type': 'application/json'}
          ,body: jsonEncode(persons)
      );

      Get.back();

      log('>>>> ${res.statusCode} and ${res.body}');

      if(res.statusCode ==  200){

        List<dynamic> json = jsonDecode(res.body);
        log('>>>> length is ${json.length}');
        attendanceDetailList = json.map((e) => AttendanceDetailsModel.fromJson(e)).toList();

      }else{
        log('>>>> Error ${res.body}');
      }


    }catch(e){
      log('>>>> exception ${e.toString()}');
    }
    return attendanceDetailList;
  }





}
