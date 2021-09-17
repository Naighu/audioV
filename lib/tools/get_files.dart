import 'dart:convert' as json;
import 'dart:io';
import 'dart:isolate';

void getAudios(SendPort port) async {
  List _songs = [];
  bool isCacheAvailable = false, dataChanged = true;
  List<FileSystemEntity> songs = [];
  final cacheAudioPath = "/storage/emulated/0/audios.json";

  File audioCache = File(cacheAudioPath);

  if (audioCache.existsSync()) {
    dataChanged = false;
    isCacheAvailable = true;
    String readJson = audioCache.readAsStringSync();
    _songs = json.jsonDecode(readJson);
    for (Map song in _songs) {
      File file = File(song["path"]);
      if (file.existsSync()) {
        songs.add(file);
      }
    }
    port.send(songs);
  }

  Directory dir = Directory('/storage/emulated/0/');

  List<FileSystemEntity> _files;

  _files = dir.listSync(recursive: true, followLinks: false);
  for (FileSystemEntity entity in _files) {
    String path = entity.path;
    if (path.endsWith('.mp3') &&
        !path.startsWith("/storage/emulated/0/Android")) {
      if (isCacheAvailable) {
        bool isAvailable = false;

        int i = 0;
        for (Map s in _songs) {
          if (s["path"] == path) {
            isAvailable = true;
            File file = File(path);
            if (DateTime.parse(s["date"]) != file.lastModifiedSync()) {
              if (!dataChanged) dataChanged = true;
              songs.insert(0, file);
              s["path"] = path;
              s["date"] = file.lastModifiedSync().toString();
              _songs[i] = s;
            } else
              break;
          }
          i++;
        }
        if (!isAvailable) {
          if (!dataChanged) dataChanged = true;
          songs.insert(0, File(path));
          _songs.insert(0,
              {"path": path, "date": File(path).lastModifiedSync().toString()});
        }
      } else {
        final file = File(path);
        Map a = {"path": path, "date": file.lastModifiedSync().toString()};
        _songs.add(a);
        songs.add(file);
      }
    }
  }
  if (dataChanged) {
    port.send(songs);
    audioCache.writeAsStringSync(json.jsonEncode(_songs));
  }
}
