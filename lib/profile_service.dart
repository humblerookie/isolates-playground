import 'package:rxdart/rxdart.dart';

import 'isolate_module.dart';

class ProfileService {
  Observable getUserSlug() {
    return Observable.just(getInt()).asyncMap((t){
      return startIsolate(t);
    });
  }
  Future<int> getIsolateData() async {
    return startIsolate(getInt());
  }
  int getInt(){
    return 20;
  }
}


ProfileService profileService = ProfileService();