// ignore_for_file: unnecessary_new, curly_braces_in_flow_control_structures

mixin Validators {
  String? validateFullName(String? name) {
    if (name!.trim().isEmpty) {
      return "Name can't be empty";
    }
    return null;
  }

  String? fieldName(String? name) {
    if (name!.trim().isEmpty) {
      return "Field can't be empty";
    }
    return null;
  }

  String? validateBankName(String? name) {
    if (name!.trim().isEmpty) {
      return "Bank can't be empty";
    }
    return null;
  }

  String? validateBankNumber(String? name) {
    if (name!.trim().isEmpty) {
      return "Account Number can't be empty";
    }
    return null;
  }

  String? validateEmailForm(String? email) {
    if ((email ?? "").trim().isEmpty) return "Email can't be empty";
    // return validateEmail(email ?? "") ? null : "Enter a valid email";
  }

  validateEmail(String? email) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(email!.trim())) {
      return false;
    } else {
      return true;
    }
  }

  String? validateUserForm(String? username) {
    if ((username ?? "").trim().isEmpty) return "Username can't be empty";
    return validateUsername(username ?? "") ? null : "use only a-z 0-9 _ .";
  }

  validateUsername(String? username) {
    Pattern pattern = r'^[a-z0-9_.]+$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(username!.trim())) {
      return false;
    } else {
      return true;
    }
  }

  String? validatePhone(String? phone) {
    if ((phone ?? "").trim().isEmpty) return "Phone number can't be empty";
    // if ((phone ?? "").trim().length < 10) return "Phone number should be 10 digits";
    return null;
  }

  String? validatePhoneNumberForm(String pwd) {
    if (pwd.trim().isEmpty) return "Phone Number can't be empty";
    return null;
  }

  String? validatePassword(String? password) {
    if ((password ?? "").trim().isEmpty) {
      return "Password can't be empty";
    } else if ((password ?? "").trim().length <= 5) {
      return "Password character length must be atleast 6";
    } else {
      return null;
    }
  }

  String? validateCardNumber(String? password) {
    if ((password ?? "").trim().isEmpty) {
      return "CardNumber can't be empty";
    } else if ((password ?? "").trim().length <= 12) {
      return "CardNumber length must be atleast 12";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String confirmPassword, {String? newPassword}) {
    if (confirmPassword.trim().isEmpty) {
      return "Confirm password can't be empty";
    } else if (confirmPassword.trim() != newPassword?.trim()) {
      return "Password doesn't match";
    }
    return null;
  }

  String? otherField(String? pwd) {
    if (pwd!.trim().isEmpty) return "Field can't be empty";
    return null;
  }

  String? validateName(String? name) {
    if ((name ?? "").trim().isEmpty) return "Full name can't be empty";
    return null;
  }

  String? validateDOB(String? dob) {
    if ((dob ?? "").trim().isEmpty) {
      return "Please fill DOB";
    }
    return null;
  }

  String? validateGender(String? gender) {
    if ((gender ?? "").trim().isEmpty) return "Please fill Gender";
    return null;
  }
}
