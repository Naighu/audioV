import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String getHumanReadableSize(int length) {
  FileSize fileSize = FileSize(length);

  if (fileSize.totalBytes < 1024)
    return "${fileSize.totalBytes.truncate()} bytes";
  if (fileSize.totalKiloBytes < 1024)
    return "${fileSize.totalKiloBytes.truncate()} KB";
  if (fileSize.totalMegaBytes < 1024)
    return "${fileSize.totalMegaBytes.truncate()} MB";
  return "${fileSize.totalGigaBytes.truncate()} GB";
}

String getHumanReadableDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0)
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  else
    return "$twoDigitMinutes:$twoDigitSeconds";
}
