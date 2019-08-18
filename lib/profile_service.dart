import 'package:isolate_playground/stream_transformer.dart';
import 'package:rxdart/rxdart.dart';

import 'isolate_module.dart';

class ProfileService {
  Observable getUserSlug() {
    return Observable.just(getInt())
        .transform(IoTransformer<int, int>(calculateFibN));
  }

  Future<int> getIsolateData() async {
    return startIsolate(getInt());
  }

  int getInt() {
    return 20;
  }
}

ProfileService profileService = ProfileService();
