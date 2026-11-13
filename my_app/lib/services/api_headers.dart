import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, String>> authenticatedHeaders({bool json = false}) async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (token == null || token.isEmpty) {
    throw StateError('A signed-in user is required for this request.');
  }

  return {
    'Authorization': 'Bearer $token',
    if (json) 'Content-Type': 'application/json',
  };
}
