import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlService(String url) async {
  final Uri uri = Uri.parse(url);
  await launchUrl(uri);
}