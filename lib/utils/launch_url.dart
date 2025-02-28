import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneUri';
  }
}

Future<void> makeSms(String phoneNumber) async {
  final Uri uri = Uri(scheme: 'sms', path: phoneNumber);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

Future<void> launchUrlLink(
  String url, {
  bool? isOpenBrowser,
  bool forceOpen = false,
}) async {
  Uri uri = Uri.parse(url);
  if (forceOpen && uri.scheme.isEmpty) {
    uri = uri.replace(scheme: 'https');
  }
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: (isOpenBrowser ?? false) ? LaunchMode.externalApplication : LaunchMode.platformDefault,
    );
  }
}
