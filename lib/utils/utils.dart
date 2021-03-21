import 'package:uuid/uuid.dart';

String generateRandomId() {
  return Uuid().v4();
}
