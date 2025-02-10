class DataFormatUtils {
  static String formatPhoneNumberCode(String phoneNumber, String countryCode) {
    // Loại bỏ tất cả các ký tự không phải số
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Loại bỏ số 0 ở đầu nếu có
    if (digitsOnly.startsWith('0')) {
      digitsOnly = digitsOnly.substring(1);
    }

    // Loại bỏ mã quốc gia nếu người dùng đã nhập
    if (digitsOnly.startsWith(countryCode)) {
      digitsOnly = digitsOnly.substring(countryCode.length);
    }

    // Nếu người dùng nhập mã quốc gia những không nhập +
    String countryCodeWithoutPlus = countryCode.replaceAll("+", '');
    if (digitsOnly.startsWith(countryCodeWithoutPlus)) {
      digitsOnly = digitsOnly.substring(countryCodeWithoutPlus.length);
    }

    // Kết hợp mã quốc gia và số điện thoại đã xử lý
    return countryCode + digitsOnly;
  }

  static String formatPhoneWithSpaces(String phoneNumber) {
    // Tách chuỗi số thành nhóm 3 chữ số
    // return phoneNumber.replaceAllMapped(RegExp(r".{1,3}"), (match) => "${match.group(0)} ");
    return phoneNumber.replaceAllMapped(
      RegExp(r'(\d{4})(\d{3})(\d{3})?'),
      (Match m) => '${m[1]} ${m[2]} ${m[3] ?? ''}'.trim(),
    );
  }
}
