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



class Shared {
  static final Shared _instance = Shared._internal();

  SharedPreferences? _sharedPreferences;

  factory Shared() {
    return _instance;
  }

  Shared._internal();

  Future<void> _initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Shared get instance => _instance;

  Future<void> setLiveUser(String data) async {
    if (_sharedPreferences == null) {
      await _initialize();
    }
    _sharedPreferences!.setString("liveUser", data);
  }

  Future<String?> getLiveUser() async {
    if (_sharedPreferences == null) {
      await _initialize();
    }
    return _sharedPreferences!.getString("liveUser");
  }
}