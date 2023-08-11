class FieldValidator {

  static String? validateEmail(String value) {

    if (value.isEmpty) {
      return 'Email is Required';
    }
    if (!RegExp(
        r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
        .hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  static String? validatePostCode(String value){
    if(value.isEmpty){
      return 'PostCode is required';
    }

    if (!RegExp(
        r"^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([AZa-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))[0-9][A-Za-z]{2})$")
        .hasMatch(value)) {
      return 'Please enter a valid PostCode';
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 9) return "Password is too short";

    return null;
  }

  static String? validateWeight(String value) {
    if (value.isEmpty) return "Weight is required";


    return null;
  }

  static String? validatePersonalSummary(String value) {
    if (value.isEmpty) return "Personal Summary is required";
    if (value.length < 15) return "Personal Summary is too short";

    return null;
  }

  static String? validateReview(String value) {
    if (value.isEmpty) return "Review is required";
    if (value.length < 15) return "Review is too short";

    return null;
  }


  static String? validateHeight(String value) {
    if (value.isEmpty) return "Height is required";


    return null;
  }

  static String? validateDate(String value) {
    if (value.isEmpty) return "Date of birth is required";


    return null;
  }

  static String? validatePasswordMatch(String value, String pass2) {
    if (value.isEmpty) return "Confirm password is required";
    if (value != pass2) {
      return "Password doesn't match";
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) return "First name is required";
    if (value.length <= 2) {
      return "First name is too short";
    }
    return null;
  }

  static String? validateLastName(String value) {
    if (value.isEmpty) return "Last name is required";
    if (value.length <= 2) {
      return "Last name is too short";
    }
    return null;
  }



  static String? validateUserName(String value) {
    if (value.isEmpty) return "Name is required";
    if (value.length <= 2) {
      return "Name is too short";
    }

    return null;
  }

  static String? validateEmpty(String value) {
    if (value.isEmpty) return "Password is required";

    return null;
  }


  static String? validateAddress(String value) {
    if (value.isEmpty) return "Address is required";
    if (value.length <= 3) {
      return "Address is too short";
    }

    return null;
  }

  static String? validateLocation(String value) {
    if (value.isEmpty) return "Location is required";
    if (value.length <= 1) {
      return "Location is too short";
    }

    return null;
  }

  static String? validateHourlyRate(String value) {
    if (value.isEmpty) return "Hourly rate is required";
    if (value.length < 1) {
      return "hourly rate is too short";
    }

    return null;
  }

  static String? validateDescription(String value) {
    if (value.isEmpty) return "Description is required";
    if (value.length <= 10) {
      return "Description is too short";
    }

    return null;
  }


  static String? validatePinCode(String? value) {
    if (value!.isEmpty) {
      return "Incorrect PINCODE";
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) return "Phone number is required";
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{8,14}$)';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value.trim())) {
      return "Please enter a valid company number";
    }
    return null;
  }


  static String? ukValidatePhoneNumber(String value) {
    if (value.isEmpty) return "Phone number is required";
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value.trim())) {
      return "Please enter a valid company number";
    }
    return null;
  }


  static String? validateJobRole(String value) {
    if (value.isEmpty) return "Job Role is required";
    if (value.length < 15) return "Job role is too short";

    return null;
  }


  static String? validateCompanyName(String value) {
    if (value.isEmpty) return "Company Name is required";

    return null;
  }

  static String? validateCompanyPosition(String value) {
    if (value.isEmpty) return "Company Position is required";
    if (value.length < 3) return "Company Position is too short";

    return null;
  }


  static String? validateServiceHourlyRate(String value,double max,double min) {
    if(value.isEmpty) return "Hourly rate is required";
    if (double.tryParse(value)! < min) return "Hourly rate should not\nbe less then ${min}";
    if (double.tryParse(value)! > max) return "Hourly rate should not\nbe exceed then ${max}";

    return null;
  }


}