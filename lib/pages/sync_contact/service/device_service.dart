import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

enum ContactPermission { granted, limited, denied, deniedForever }

class ContactService {
  static Future<ContactPermission> checkContactPermission() async {
    final status = await Permission.contacts.status;

    return _toContactPermission(status);
  }

  static Future<PermissionStatus> requestSystemAlertPermission() async {
    final status = await Permission.systemAlertWindow.request();

    return status;
  }

  static Future<ContactPermission> requestContactPermission() async {
    final status = await Permission.contacts.request();

    return _toContactPermission(status);
  }

  static Future<void> openAppSetting() async {
    await openAppSettings();
  }

  static Future<List<Contact>> getDeviceContact() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      return [];
    } else {
      return FlutterContacts.getContacts(withProperties: true);
    }
  }

  static ContactPermission _toContactPermission(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return ContactPermission.granted;
      case PermissionStatus.limited:
        return ContactPermission.limited;
      case PermissionStatus.restricted:
        return ContactPermission.denied;
      case PermissionStatus.provisional:
        return ContactPermission.granted;
      case PermissionStatus.denied:
        return ContactPermission.denied;
      case PermissionStatus.permanentlyDenied:
        return ContactPermission.deniedForever;
    }
  }
}
