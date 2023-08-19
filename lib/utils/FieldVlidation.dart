class FieldValidators {

  static String? validatePhone(String value) {

    if (value.isEmpty) {
      return 'Phone is Required';
    }
    if (!RegExp(
        r'^\d{11}$')
        .hasMatch(value)) {
      return 'Please enter a valid Phone';
    }
    return null;
  }

  static String? validateCustomerInfo(String value) {
    if (value.isEmpty) return "Custom Info is required";

    return null;
  }


  static String? validateOwnerName(String value) {
    if (value.isEmpty) return "Owner name is required";

    return null;
  }

  static String? validateCustomerAddress(String value) {
    if (value.isEmpty) return "Address is required";

    return null;
  }


  static String? validateOwnerCnic(String value) {
    if (value.isEmpty) return "Cnic is required";

    return null;
  }

  static String? validateStrn(String value) {
    if (value.isEmpty) return "Strn is required";

    return null;
  }


  static String? validateNtn(String value) {
    if (value.isEmpty) return "Strn is required";

    return null;
  }


}