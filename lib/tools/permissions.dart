import 'package:permission_handler/permission_handler.dart';

Future<bool> androidPermission(Permission p) async {
  var status = await p.status;
  while (status.isDenied) {
    status = await p.request();
  }
  if (status.isPermanentlyDenied) {
    return false;
  }
  return true;
}
