import 'dart:async';
import 'dart:io';

import 'package:audiov/models/audio_data.dart';
import 'package:audiov/tools/get_metadata.dart';

// void getAudios(SendPort port) async {
//   List _songs = [];
//   bool isCacheAvailable = false, dataChanged = true;
//   List<FileSystemEntity> songs = [];
//   final cacheAudioPath = "/storage/emulated/0/audios.json";

//   File audioCache = File(cacheAudioPath);

//   if (audioCache.existsSync()) {
//     dataChanged = false;
//     isCacheAvailable = true;
//     String readJson = audioCache.readAsStringSync();
//     _songs = json.jsonDecode(readJson);
//     for (Map song in _songs) {
//       File file = File(song["path"]);
//       if (file.existsSync()) {
//         songs.add(file);
//       }
//     }
//     port.send(songs);
//   }

//   Directory dir = Directory('/storage/emulated/0/');

//   List<FileSystemEntity> _files;

//   _files = dir.listSync(recursive: true, followLinks: false);
//   for (FileSystemEntity entity in _files) {
//     String path = entity.path;
//     if (path.endsWith('.mp3') &&
//         !path.startsWith("/storage/emulated/0/Android")) {
//       if (isCacheAvailable) {
//         bool isAvailable = false;

//         int i = 0;
//         for (Map s in _songs) {
//           if (s["path"] == path) {
//             isAvailable = true;
//             File file = File(path);
//             if (DateTime.parse(s["date"]) != file.lastModifiedSync()) {
//               if (!dataChanged) dataChanged = true;
//               songs.insert(0, file);
//               s["path"] = path;
//               s["date"] = file.lastModifiedSync().toString();
//               _songs[i] = s;
//             } else
//               break;
//           }
//           i++;
//         }
//         if (!isAvailable) {
//           if (!dataChanged) dataChanged = true;
//           songs.insert(0, File(path));
//           _songs.insert(0,
//               {"path": path, "date": File(path).lastModifiedSync().toString()});
//         }
//       } else {
//         final file = File(path);
//         Map a = {"path": path, "date": file.lastModifiedSync().toString()};
//         _songs.add(a);
//         songs.add(file);
//       }
//     }
//   }
//   if (dataChanged) {
//     port.send(songs);
//     audioCache.writeAsStringSync(json.jsonEncode(_songs));
//   }
// }

class MediaFiles {
  late StreamSubscription<FileSystemEntity> subscription;
  late StreamController<List<AudioData>> controller;
  int limit;
  List<String> extensions;
  MediaFiles(this.limit, this.extensions) {
    init();
  }

  void init() {
    controller = StreamController.broadcast();
    subscription = Directory("/storage/emulated/0/")
        .list(recursive: true, followLinks: false)
        .listen((event) {});
  }

  void fetchAudio() {
    List<AudioData> _audios = [];
    subscription.resume();
    int i = 0;
    subscription.onData(
      (data) async {
        if (i < limit) {
          String path = data.path;
          if (_checkForFiles(path) &&
              !path.startsWith("/storage/emulated/0/Android")) {
            ;

            _audios.add(await getMetaData(File(data.path)));
            i++;
          }
        } else {
          subscription.pause();
          controller.add(_audios);
          i = 0;
        }
      },
    );
    subscription.onDone(() {
      controller.add(_audios);
    });
  }

  bool _checkForFiles(String path) {
    for (String ext in extensions) {
      if (path.endsWith(ext)) return true;
    }
    return false;
  }
}
