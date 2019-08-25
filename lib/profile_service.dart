import 'package:isolate_playground/stream_transformer.dart';
import 'package:rxdart/rxdart.dart';

import 'isolate_module.dart';

class ProfileService {
  Observable getUserSlug(int input) {
    return Observable.just(input)
        .transform(IoTransformer<int, int>(calculateFib));
  }

  Future<int> getIsolateData() async {
    return startIsolate(getInt());
  }

  int getInt() {
    return 20;
  }
}

ProfileService profileService = ProfileService();
