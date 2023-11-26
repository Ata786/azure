import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/data/sharedPreference.dart';
import 'package:SalesUp/main.dart';
import 'package:SalesUp/model/attendenceModel.dart';
import 'package:SalesUp/model/userLiveModel.dart';
import 'package:SalesUp/model/userModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/localNotification.dart';
import 'package:SalesUp/utils/toast.dart';
import 'package:SalesUp/utils/userCurrentLocation.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/updateLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';


class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  double checkInLat = 0.0;
  double checkInLon = 0.0;
  String checkInDate = '00:00';
  List<Marker> checkInMarker = [];
  late GoogleMapController checkInMapController;

  double checkOutLat = 0.0;
  double checkOutLon = 0.0;
  String checkOutDate = '00:00';
  List<Marker> checkOutMarker = [];
  late GoogleMapController checkOutMapController;

  @override
  void initState() {
    getCheckIn();
    super.initState();
  }


  TextEditingController distanceCtr = TextEditingController(text: "0.5");
  TextEditingController remarksCtr = TextEditingController(text: "");

  void getCheckIn()async{
    UserController userController = Get.find<UserController>();
    CheckIn checkIn = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
    userController.checkIn.value = checkIn;

    CheckOut checkOut = await HiveDatabase.getCheckOutAttendance("checkOutAttendance", "checkOut");
    userController.checkOut.value = checkOut;

    RemarksModel remarksModel = await HiveDatabase.getRemarks("remarksBox", 'remarks');
    distanceCtr.text = remarksModel.checkIn ?? "0.5";
    remarksCtr.text = remarksModel.remarks ?? "";
  }


  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    checkInMarker.add(Marker(markerId: MarkerId("0"),position: LatLng(userController.checkIn.value.latitude ?? 0.0, userController.checkIn.value.longitude ?? 0.0)));
    checkOutMarker.add(Marker(markerId: MarkerId("0"),position: LatLng(double.tryParse(userController.checkOut.value.outLatitude.toString()) ?? 0.0, double.tryParse(userController.checkOut.value.outLongitude.toString()) ?? 0.0)));
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        actions: [
          Center(
            child: InkWell(
              onTap: (){
                Get.to(UpdateLocationScreen());
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: FetchPixels.getPixelWidth(20),)
        ],
        title: Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: (){
                        getLocation(context).then((value) async{
                            if(value != null){
                              if(userController.isOnline.value == true){
                              markAttendance();
                               }else{
                                checkInLat = value.latitude;
                                checkInLon = value.longitude;
                                DateTime now = DateTime.now();
                                DateFormat dateFormat = DateFormat('dd MMM yyyy hh:mm a');
                                checkInDate = dateFormat.format(now);
                                checkInMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(checkInLat, checkInLon),zoom: 12)));
                                CheckIn checkIn = CheckIn(latitude: checkInLat,longitude: checkInLon,attendanceDateTime: checkInDate);
                                await HiveDatabase.setCheckInAttendance("checkInAttendance", "checkIn", checkIn);
                                CheckIn check = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
                                userController.checkIn.value = check;

                                if(userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF"){
                                }else {
                                  ForegroundServiceHandler.notification.setTitle("Sales Up");
                                  ForegroundServiceHandler.notification.setText("Running...");
                                  ForegroundService().start();
                                  Workmanager().registerPeriodicTask(fetchBackground, fetchBackground,frequency: Duration(minutes: 30));
                                }
                                setState(() {
                                });
                              }
                              }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                          height: FetchPixels.height / 15,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0xffADD8E6),
                              borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "Check In",
                        style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                      ),
                    )),
                Expanded(
                    child: InkWell(
                      onTap: (){
                        getLocation(context).then((value) async{
                            if(value != null){
                              checkOutLat = value.latitude;
                              checkOutLon = value.longitude;
                              DateTime now = DateTime.now();
                              DateFormat dateFormat = DateFormat('dd MMM yyyy hh:mm a');
                              checkOutDate = dateFormat.format(now);
                              checkOutMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(checkOutLat, checkOutLon),zoom: 12)));
                              CheckOut checkOut = CheckOut(userId: "",outLatitude: checkOutLat,outLongitude: checkOutLon,outAttendanceDateTime: checkOutDate);
                              await HiveDatabase.setCheckOutAttendance("checkOutAttendance", "checkOut", checkOut);
                              CheckOut check = await HiveDatabase.getCheckOutAttendance("checkOutAttendance", "checkOut");
                              userController.checkOut.value = check;
                            }
                            setState(() {

                            });

                            String director = "";

                            if(userController.user!.value.designation!.startsWith("Director")){
                              director = "Director";
                            }else{
                              director = "";
                            }

    if(userController.user!.value.designation == "Admin" || userController.user!.value.designation == "NSM"
    || userController.user!.value.designation == "Managing Director" || userController.user!.value.designation == "GM Sales"
    || director == "Director"){

    }else{


      if(userController.isOnline.value == true){

        List<UserLiveModel> live = [];

        if(Hive.isAdapterRegistered(25)){
          live = await HiveDatabase.getUserLive("live", "liveBox");

        }else{
          var directory = await getApplicationDocumentsDirectory();
          Hive
            ..init(directory.path);
          Hive.registerAdapter(UserLiveModelAdapter());
          live = await HiveDatabase.getUserLive("live", "liveBox");
        }

        CheckOut check = await HiveDatabase.getCheckOutAttendance("checkOutAttendance", "checkOut");
        CheckIn checkIn = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
        RemarksModel remarksModel = await HiveDatabase.getRemarks("remarksBox", 'remarks');

        DateFormat inputFormat = DateFormat("dd MMM y hh:mm a");

        DateTime dateTime = inputFormat.parse(check.outAttendanceDateTime!);
        String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime);

        DateTime checkInDateTime = inputFormat.parse(checkIn.attendanceDateTime!);
        String checkInFormattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(checkInDateTime);

        Map<String,dynamic> checkOut = {
          "id": checkIn.id,
          "userId": userController.user!.value.id,
          "latitude": checkIn.latitude,
          "longitude": checkIn.longitude,
          "attendanceDateTime": checkInFormattedDateTime,
          "outLongitude": check.outLongitude,
          "outLatitude": check.outLatitude,
          "outAttendanceDateTime": formattedDateTime,
          "checkIn": remarksModel.checkIn ?? "0.5",
          "remarks": remarksModel.remarks ?? "",
        };

        log('>>>> request ${checkOut}');

        await updateSaleAttendance(checkOut,live);

      }else{
        showToast(context, "");
      }

    }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                  height: FetchPixels.height / 15,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                        color: Color(0xffADD8E6),
                        borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          "Check Out",
                          style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                ),
                    )),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            Row(
              children: [
                Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Obx(() => Text(
                        userController.checkIn.value.attendanceDateTime ?? "00:00",
                        style: TextStyle(color: Colors.black,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),)
                    ),),
                Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Obx(() => Text(
                        userController.checkOut.value.outAttendanceDateTime ?? "00:00",
                        style: TextStyle(color: Colors.black,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      )),
                    ),),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            Row(
              children: [
                Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 3,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffADD8E6),
                          borderRadius: BorderRadius.circular(7)),
                      child: Obx(() => GoogleMap(zoomControlsEnabled: false,
                        markers: Set.of(checkInMarker),
                        initialCameraPosition: CameraPosition(zoom: 13,target: LatLng(userController.checkIn.value.latitude ?? 0.0, userController.checkIn.value.longitude ?? 0.0)
                        ),
                        onMapCreated: (controller){
                          checkInMapController = controller;
                        },
                      )
                      )
                    )),
                Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 3,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffADD8E6),
                          borderRadius: BorderRadius.circular(7)),
                        child: Obx(() => GoogleMap(zoomControlsEnabled: false,initialCameraPosition: CameraPosition(zoom: 13,target: LatLng(double.tryParse(userController.checkOut.value.outLatitude.toString()) ?? 0.0, double.tryParse(userController.checkOut.value.outLongitude.toString()) ?? 0.0),
                        ),
                          markers: Set.of(checkOutMarker),
                          onMapCreated: (controller){
                            checkOutMapController = controller;
                          },
                        ))
                    )),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Container(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                width: FetchPixels.getPixelWidth(180),
                child: textField(controller: distanceCtr,readOnly: true,labelText: "Distance",hintText: "Distance")),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Container(
                padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                width: FetchPixels.width,
                child: textField(controller: remarksCtr,labelText: "Remark",hintText:"Remark")),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            InkWell(
              onTap: (){
               HiveDatabase.setRemarks("remarksBox", 'remarks', RemarksModel(remarks: remarksCtr.text,checkIn: distanceCtr.text));
              },
              child: Container(
                alignment: Alignment.center,
                width: FetchPixels.width/3.2,
                height: FetchPixels.height / 18,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffADD8E6),
                    borderRadius: BorderRadius.circular(7)),
                child: Center(
                  child: Text(
                    "Update Remarks",
                    style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(13),fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }




  Future<void> markAttendance() async {
    UserController userController = Get.find<UserController>();
    final url = Uri.parse('http://125.209.79.107:7700/api/Attendance');


    final response = await http.post(
      url,
      body: jsonEncode({"userId": userController.user!.value.id,"latitude": userController.latitude,"longitude": userController.longitude,"attendanceDateTime": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now())}),
      headers: {'Content-Type': 'application/json'},
    );



    if(userController.user!.value.designation == "Booker" || userController.user!.value.designation == "CSF"){

    }else{
      ForegroundServiceHandler.notification.setTitle("Sales Up");
      ForegroundServiceHandler.notification.setText("Running...");
      ForegroundService().start();
      Workmanager().registerPeriodicTask(fetchBackground, fetchBackground,frequency: Duration(minutes: 30));

      DateTime now = DateTime.now();
      DateTime desiredTime = DateTime(now.year, now.month, now.day, 19, 0);
      int initialDelay = desiredTime.isAfter(now) ? desiredTime.difference(now).inSeconds : 24 * 60 * 60 - now.difference(desiredTime).inSeconds;

      log('>>>> delay ${initialDelay}');

      Workmanager().registerPeriodicTask(
        fetchBackground2,
        fetchBackground2,
        frequency: Duration(hours: 24),
        initialDelay: Duration(seconds: initialDelay),
      );

    }



    log('>>> response ${response.statusCode} and ${response.body}');
    log('>>>> code ${userController.user!.value.id} and ${userController.latitude} and ${userController.longitude}');
    if (response.statusCode == 200) {
      Map<String,dynamic> attendanceParse = jsonDecode(response.body);
      String userId = attendanceParse['userId'];
      String date = attendanceParse['attendanceDateTime'];
      getAttendanceData(userId,date);
      Fluttertoast.showToast(
          msg: "Your Attendance is Successfully marked",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: themeColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      getAttendanceData(userController.user!.value.id!,DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now()));
      Fluttertoast.showToast(
          msg: "Your Attendance is Already Marked",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: themeColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  Future getAttendanceData(String userId,String date) async {
    UserController userController = Get.find<UserController>();
    final url =
    Uri.parse('http://125.209.79.107:7700/api/Attendance/${userId}/${date}');
    final response = await http.get(url);
    log('>>>> get Attendance ${response.statusCode} and ${response.body}');
    if (response.statusCode == 200) {
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      CheckIn checkInParse = CheckIn.fromJson(jsonData);
      CheckIn checkIn = CheckIn(latitude: double.parse(checkInParse.latitude.toString()),longitude: double.parse(checkInParse.longitude.toString()),attendanceDateTime: DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(checkInParse.attendanceDateTime!)),id: checkInParse.id,userId: checkInParse.userId,outLongitude: double.parse(checkInParse.outLongitude.toString()),outLatitude: double.parse(checkInParse.outLatitude.toString()),outAttendanceDateTime: checkInParse.outAttendanceDateTime);
      HiveDatabase.setCheckInAttendance("checkInAttendance", "checkIn", checkIn);
      CheckIn check = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
      userController.checkIn.value = check;
      getLocation(context).then((value) async{
        if(value != null){
          checkInLat = value.latitude;
          checkInLon = value.longitude;
          checkInMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(checkInLat, checkInLon),zoom: 12)));
        }
      });
      setState(() {
      });
    } else {
      throw Exception(
          'Failed to fetch attendance data. Error:${response.body}');
    }

  }


}



