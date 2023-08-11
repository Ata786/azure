import 'package:shared_preferences/shared_preferences.dart';

void setOfficeCode(String data)async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("officeCode", data);
}

Future<String?> getOfficeCode(String key)async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("officeCode");
}

void setUserDataSp(String data)async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("user", data);
}

Future<String?> getUserDataSp(String key)async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("user");
}