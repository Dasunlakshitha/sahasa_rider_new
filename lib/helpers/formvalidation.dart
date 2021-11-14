  // String validateUsername(String value) {
  //   Pattern pattern =
  //       r'/^[a-zA-Z]+$/';
  //   RegExp regex = new RegExp(pattern);
  //   if(!value)
  //     return 'Username'
  //   else if (!regex.hasMatch(value))
  //     return 'Enter Valid Email';
  //   else
  //     return null;
  // }

    String validatePhoneNo(String value) {
    Pattern pattern =
        r'/[0-9]{10}/';
    RegExp regex = new RegExp(pattern);
    if(value == '')
      return 'Phone no Required.';
    else if (!regex.hasMatch(value))
      return 'Enter Valid Phone No';
    else
      return null;
  }

  String validateUrl(String value) {
    Pattern pattern =
        r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$";
    RegExp regex = new RegExp(pattern);
    if(value == '')
      return null;
    else if (!regex.hasMatch(value))
      return 'Enter Valid URL';
    else
      return null;
  }