import 'dart:isolate';

import 'package:isolate_playground/stream_transformer.dart';
import 'package:rxdart/rxdart.dart';

import 'isolate_module.dart';

class ProfileService {
  Observable getUserSlug(int input) {
    return Observable.just(input)
        .transform(IoScheduler<int, int>(calculateFib));
  }

  Future<int> getIsolateData() async {
    return startIsolate(getInt());
  }

  int getInt() {
    return 20;
  }

  Future<Isolate> getOtherIsolate() {
    var list = List<String>();
    list.add("1");
    var response = new ReceivePort();
    return Isolate.spawnUri(Uri.parse("other.dart"), list,response.sendPort);
  }
}

ProfileService profileService = ProfileService();
