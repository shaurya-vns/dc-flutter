/// Regex constants
class RegexConstants {
  static const String hasDigitRegex = r'[0-9]';
  static const String hasLowerCaseRegex = r'[a-z]';
  static const String hasUpperCaseRegex = r'[A-Z]';
  static const String alphabetRegex = r'[a-zA-Z]';
  static const String validMobileRegex =
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
  static const String validPhoneBook =
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]';

  static const String validPhoneRegex =
      r'^[0-9]{8,17}$'; //Phone number should be in range 8 to 17 chars

  static const String hasSpaceCharacter =
      r' '; //Phone number should be in range 3 to 15 chars

  static const String validPassword =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';

  static const String validEmailRegex =
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
  // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  // I got Regex pattern from this https://stackoverflow.com/a/50663835

  static const String hasOnlyDigitRegex = r'^[0-9]*$';
  static const String hasOnlyAlphabetsRegex = r'^[a-zA-Z]*$';
  static const String hasOnlyAlphanumericWithAtLeastOneAlphabetRegex =
      r'^\d*[a-zA-Z][a-zA-Z0-9]*$';
  static const String hasSpecialCharacterRegex = r'[\W_]';

  static const String hexcolor = r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$';
  static const String numericRegex = r'^-?[0-9]+$';

  static const String checkSpecialCharForPhoneNumber = '[-()\\s]';
  static const String phoneNumberCountryCode = '^(0|62|\\+62)';
  static const String phoneNumberCompanyRegex =
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[\s\ 0-9]*$';
  static const String checkContactNameWithLastIndex = r'\((\d+).$';
  static const String phonePrefix = r'(0|\+62)';
  static const String eKTPRegex = r'^[0-9]{16}$';
  static const String pipeline = r'|';
  static const String simpleEmailValidate = r'@{1}\w+\.+';

  static const String isEmpty = 'isEmpty';
  static const String invalidPasswordMessage = 'invalidPasswordMessage';
  static const String invalidEmail = 'invalidEmail';
  static const String isEmojiMessage = 'isEmojiMessage';
  static const String invalidOTP = 'invalidOTP';
  static const String invalidMobileMessage = 'invalidMobileMessage';
  static const String isNegativeValue = 'isNegativeValue';
  static const String isLargeValue = 'isLargeValue';
  static const String invalidValue = 'invalidValue';

  /// Validates email
  static String validateEmail(String value) {
    String result = validateNonEmoji(value);
    if (result != '') return result;

    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return invalidEmail;
    } else {
      return '';
    }
  }

  /// Validates if the field is empty or not
  static String validateField(String value) {
    String result = validateNonEmoji(value);
    if (result != '') return result;

    if (value.isEmpty) {
      return isEmpty;
    } else {
      return '';
    }
  }

  /// Validates the length(4) of the OTP
  static String validateOTP(String value) {
    String result = validateNonEmoji(value);
    if (result != '') return result;

    RegExp regExp = RegExp(r'\b\d{4}\b');
    if (!regExp.hasMatch(value)) {
      return invalidOTP;
    } else {
      return '';
    }
  }

  /// Validates mobile number
  static String validateMobile(String value) {
    String result = validateNonEmoji(value);
    if (result != '') return result;

    String pattern = r'(^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return invalidMobileMessage;
    } else {
      return '';
    }
  }

  /// Validates if non-emoji is entered or not
  ///
  /// Returns null for non-emoji value
  static String validateNonEmoji(String value) {
    if (value == '' || value.trim().isEmpty) {
      return isEmpty;
    }

    String pattern =
        r'^(?:(?!(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff]))[^`☺]){1,255}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return isEmojiMessage;
    } else {
      return '';
    }
  }

  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}
