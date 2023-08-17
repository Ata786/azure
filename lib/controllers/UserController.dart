
import 'package:get/get.dart';
import '../model/attendenceModel.dart';
import '../model/officeCodeModel.dart';
import '../model/userModel.dart';

class UserController extends GetxController{

  double latitude = 0.0;
  double longitude = 0.0;
  Rx<OfficeCodeModel>? officeCode;
  Rx<UserModel>? user;
  Rx<AttendenceModel>? attendanceModel;


}